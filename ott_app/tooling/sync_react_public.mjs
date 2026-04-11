import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ottRoot = path.resolve(__dirname, '..');
const repoRoot = path.resolve(ottRoot, '..');

const reactPublic = process.argv[2] ?? path.join(repoRoot, 'devangott', 'public');
const reactDataTs = process.argv[3] ?? path.join(repoRoot, 'devangott', 'src', 'data', 'content.ts');

const outPublicDir = path.join(ottRoot, 'public');
const outJson = path.join(outPublicDir, 'content.json');

function shouldSkip(relPath) {
  const base = path.basename(relPath);
  if (base === '.DS_Store') return true;
  if (base.toLowerCase().endsWith('.zip')) return true;
  return false;
}

function copyDir(srcDir, dstDir) {
  fs.mkdirSync(dstDir, { recursive: true });
  for (const entry of fs.readdirSync(srcDir, { withFileTypes: true })) {
    const src = path.join(srcDir, entry.name);
    const dst = path.join(dstDir, entry.name);
    const rel = path.relative(srcDir, src);
    if (shouldSkip(rel)) continue;
    if (entry.isDirectory()) {
      copyDir(src, dst);
    } else if (entry.isFile()) {
      fs.mkdirSync(path.dirname(dst), { recursive: true });
      fs.copyFileSync(src, dst);
    }
  }
}

if (!fs.existsSync(reactPublic)) {
  console.error(`React public not found: ${reactPublic}`);
  process.exit(1);
}
if (!fs.existsSync(reactDataTs)) {
  console.error(`React content.ts not found: ${reactDataTs}`);
  process.exit(1);
}

console.log(`Copying images from ${reactPublic} -> ${outPublicDir}`);
copyDir(reactPublic, outPublicDir);

console.log(`Generating ${outJson} from ${reactDataTs}`);
const extractScript = path.join(ottRoot, 'tooling', 'extract_web_content.mjs');
const r = spawnSync('node', [extractScript, reactDataTs, outJson], {
  stdio: 'inherit',
});
process.exit(r.status ?? 1);
