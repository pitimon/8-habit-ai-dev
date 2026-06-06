#!/usr/bin/env node
// Generate a stable, portable catalog from skills/*/SKILL.md frontmatter.
// Dependency-free by design: runs on macOS, Linux, WSL, and GitHub Actions.

const fs = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "..");
const skillsDir = path.join(root, "skills");
const outPath = path.join(root, "docs", "data", "skills.json");

function usage() {
  console.log("Usage: node scripts/generate-skill-catalog.js [--check]");
}

function parseArgs(argv) {
  const args = new Set(argv.slice(2));
  if (args.has("-h") || args.has("--help")) {
    usage();
    process.exit(0);
  }
  for (const arg of args) {
    if (arg !== "--check") {
      console.error(`ERROR: unknown argument: ${arg}`);
      usage();
      process.exit(2);
    }
  }
  return { check: args.has("--check") };
}

function parseScalar(raw) {
  const value = raw.trim();
  if (value === "true") return true;
  if (value === "false") return false;
  return value.replace(/^["']|["']$/g, "");
}

function parseInlineArray(raw) {
  const value = raw.trim();
  if (!value.startsWith("[") || !value.endsWith("]")) return [];
  return value
    .slice(1, -1)
    .split(",")
    .map((item) => item.trim().replace(/^["']|["']$/g, ""))
    .filter(Boolean);
}

function parseFrontmatter(content, filePath) {
  const lines = content.split(/\r?\n/);
  if (lines[0] !== "---") {
    throw new Error(`${filePath}: missing opening frontmatter delimiter`);
  }

  const end = lines.findIndex((line, index) => index > 0 && line === "---");
  if (end === -1) {
    throw new Error(`${filePath}: missing closing frontmatter delimiter`);
  }

  const fields = {};
  for (let i = 1; i < end; i += 1) {
    const line = lines[i];
    const match = line.match(/^([A-Za-z][A-Za-z0-9_-]*):\s*(.*)$/);
    if (!match) continue;

    const [, key, raw] = match;
    if (raw.trim() === ">") {
      const parts = [];
      i += 1;
      while (i < end && /^\s+/.test(lines[i])) {
        parts.push(lines[i].trim());
        i += 1;
      }
      i -= 1;
      fields[key] = parts.join(" ").replace(/\s+/g, " ").trim();
    } else if (raw.trim().startsWith("[")) {
      fields[key] = parseInlineArray(raw);
    } else {
      fields[key] = parseScalar(raw);
    }
  }

  return fields;
}

function inferBodyMetadata(content) {
  const stepMatch = content.match(/^#\s+Step\s+([0-9]+):/m);
  const habitMatch = content.match(/\*\*Habit\*\*:\s*(H[0-9])/);
  return {
    workflow_step: stepMatch ? Number(stepMatch[1]) : null,
    habit: habitMatch ? habitMatch[1] : null,
  };
}

function readSkills() {
  return fs
    .readdirSync(skillsDir, { withFileTypes: true })
    .filter((entry) => entry.isDirectory())
    .map((entry) => entry.name)
    .sort()
    .map((dirName) => {
      const filePath = path.join(skillsDir, dirName, "SKILL.md");
      if (!fs.existsSync(filePath)) {
        throw new Error(`${filePath}: missing SKILL.md`);
      }

      const content = fs.readFileSync(filePath, "utf8");
      const frontmatter = parseFrontmatter(content, filePath);
      const body = inferBodyMetadata(content);

      return {
        name: frontmatter.name || dirName,
        path: `skills/${dirName}/SKILL.md`,
        description: frontmatter.description || "",
        user_invocable: Boolean(frontmatter["user-invocable"]),
        argument_hint: frontmatter["argument-hint"] || null,
        allowed_tools: frontmatter["allowed-tools"] || [],
        prev_skill: frontmatter["prev-skill"] || null,
        next_skill: frontmatter["next-skill"] || null,
        disable_model_invocation:
          frontmatter["disable-model-invocation"] === undefined
            ? null
            : frontmatter["disable-model-invocation"],
        workflow_step: body.workflow_step,
        habit: body.habit,
        compatibility: {
          claude_code: true,
          codex: true,
          macos: true,
          linux: true,
          wsl: true,
          requires_claude_hook: false,
        },
      };
    });
}

function renderCatalog(skills) {
  const catalog = {
    schema_version: 1,
    generated_by: "scripts/generate-skill-catalog.js",
    source: "skills/*/SKILL.md",
    compatibility_note:
      "Catalog describes portable markdown skills. Claude hooks are Claude Code-only and are not Codex runtime behavior.",
    skills,
  };
  return `${JSON.stringify(catalog, null, 2)}\n`;
}

function main() {
  const { check } = parseArgs(process.argv);
  const rendered = renderCatalog(readSkills());

  if (check) {
    if (!fs.existsSync(outPath)) {
      console.error(`ERROR: ${path.relative(root, outPath)} is missing`);
      process.exit(1);
    }
    const current = fs.readFileSync(outPath, "utf8");
    if (current !== rendered) {
      console.error(
        `ERROR: ${path.relative(root, outPath)} is stale. Run: node scripts/generate-skill-catalog.js`,
      );
      process.exit(1);
    }
    console.log(`${path.relative(root, outPath)} is fresh`);
    return;
  }

  fs.mkdirSync(path.dirname(outPath), { recursive: true });
  fs.writeFileSync(outPath, rendered);
  console.log(`Generated ${path.relative(root, outPath)}`);
}

main();
