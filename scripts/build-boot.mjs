import fs from 'node:fs/promises';
import path from 'node:path';
import { stripTypeScriptTypes } from 'node:module';

export async function buildBoot(root, write) {
  const dir = path.join(root, 'src/boot/upstream');
  for (const file of await fs.readdir(dir)) {
    if (!file.endsWith('.ts')) continue;
    let source = await fs.readFile(path.join(dir, file), 'utf8');
    source = source.replace('import { themeAmount } from "./theme-ui";', 'const themeAmount = 0;')
      .replace('import artwork from "./boot-lettering-art.json";', `const artwork = ${await fs.readFile(path.join(dir, 'boot-lettering-art.json'), 'utf8')};`)
      .replace('import "./boot-lettering.css";', '')
      .replace('import { assetUrl } from "./asset-url";', 'const assetUrl = path => path; const __RHINE_NOVECENTO__ = false;')
      .replace('declare const __RHINE_NOVECENTO__: boolean;', '')
      .replace(/from "(\.\/[^".]+)"/g, 'from "$1.js"');
    await write(`assets/boot/${file.replace('.ts', '.js')}`, stripTypeScriptTypes(source, { mode: 'transform' }));
  }
  await write('assets/boot/boot.css', await fs.readFile(path.join(root, 'src/boot/boot.css')));
  await write('assets/boot/entry.js', await fs.readFile(path.join(root, 'src/boot/entry.js')));
  await write('assets/boot/boot-lettering.css', await fs.readFile(path.join(dir, 'boot-lettering.css')));
  for (const weight of ['regular','semibold','bold']) await write(`assets/boot/${weight}.woff2`, await fs.readFile(path.join(root, `src/boot/fonts/${weight}.woff2`)));
  return await fs.readFile(path.join(root, 'src/boot/bridge.html'), 'utf8');
}
