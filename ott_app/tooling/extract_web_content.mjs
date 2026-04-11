import fs from 'node:fs';
import path from 'node:path';
import { pathToFileURL } from 'node:url';

const repoRoot = process.cwd();
const tsPath =
  process.argv[2] ?? path.join(repoRoot, '..', 'devangott', 'src', 'data', 'content.ts');
const outPath =
  process.argv[3] ?? path.join(repoRoot, 'public', 'content.json');

let src = fs.readFileSync(tsPath, 'utf8');

// Drop TS-only imports and type annotations so Node can evaluate it as ESM.
src = src.replace(/^import\s+type[^\n]*\n/gm, '');

// Convert `export const name: Type = ...` and `export const name = ...` to plain consts.
src = src.replace(/export const (\w+)\s*:\s*[^=]+=\s*/g, 'const $1 = ');
src = src.replace(/export const (\w+)\s*=\s*/g, 'const $1 = ');

// Build a default export with all top-level consts from the file.
const names = [...src.matchAll(/\bconst\s+(\w+)\s*=/g)]
  .map((m) => m[1])
  .filter((n) => n !== 'src');

const uniqueNames = [...new Set(names)];
src += `\nexport default { ${uniqueNames.join(', ')} };\n`;

const tmpPath = path.join(repoRoot, '.web_content_tmp.mjs');
fs.writeFileSync(tmpPath, src);

const mod = await import(pathToFileURL(tmpPath).href);
fs.unlinkSync(tmpPath);

fs.mkdirSync(path.dirname(outPath), { recursive: true });
fs.writeFileSync(outPath, JSON.stringify(mod.default, null, 2));

console.log(`Wrote ${outPath}`);
