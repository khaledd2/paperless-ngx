#!/usr/bin/env node
/**
 * Build a standalone, self-contained HTML viewer for the Paperless-ngx
 * end-user guides (docs/end-user-guides).
 *
 * Usage:  node scripts/build-docs-viewer.mjs
 * Output: docs-viewer.html (repo root)
 *
 * It reads every guide (English + Arabic) plus the guides index, embeds them as
 * JSON inside docs-viewer.template.html, and writes the result. Open the output
 * in any browser — no server or build step required.
 */
import { readFileSync, writeFileSync } from 'node:fs'
import { join, dirname } from 'node:path'
import { fileURLToPath } from 'node:url'

const __dirname = dirname(fileURLToPath(import.meta.url))
const root = join(__dirname, '..')
const guidesDir = join(root, 'docs', 'end-user-guides')

const read = (p) => readFileSync(p, 'utf8')

// Reading order + labels. This mirrors the "User Guides" group of the `nav` in
// zensical.toml and the tables in docs/end-user-guides/index.md.
const SECTIONS = [
  { id: 'getting-started', title: { en: 'Getting Started', ar: 'البدء' }, items: [
    ['overview', 'Overview', 'نظرة عامة'],
    ['dashboard', 'Dashboard & navigation', 'لوحة المعلومات والتنقّل'],
    ['authentication', 'Authentication, users, groups & permissions', 'المصادقة والمستخدمون والمجموعات والصلاحيات'],
  ] },
  { id: 'documents', title: { en: 'Documents', ar: 'المستندات' }, items: [
    ['adding', 'Adding documents', 'إضافة المستندات'],
    ['browsing', 'Browsing, filtering and searching', 'تصفّح المستندات وتصفيتها والبحث فيها'],
    ['viewing', 'Viewing a document', 'عرض مستند'],
    ['editing', 'Editing document details', 'تعديل تفاصيل المستند'],
    ['notes-history', 'Notes and history', 'الملاحظات والسجل'],
    ['bulk', 'Working with many documents at once', 'العمل على عدة مستندات معًا'],
    ['trash', 'Deleting and restoring documents', 'حذف المستندات واستعادتها'],
    ['sharing', 'Sharing and permissions', 'المشاركة والصلاحيات'],
  ] },
  { id: 'attributes', title: { en: 'Attributes', ar: 'الخصائص' }, items: [
    ['tags', 'Tags', 'الوسوم'],
    ['correspondents', 'Correspondents', 'المراسلون'],
    ['document-types', 'Document types', 'أنواع المستندات'],
    ['storage-paths', 'Storage paths', 'مسارات التخزين'],
    ['custom-fields', 'Custom fields', 'الحقول المخصّصة'],
  ] },
  { id: 'automation', title: { en: 'Automation', ar: 'الأتمتة' }, items: [
    ['saved-views', 'Saved views', 'العروض المحفوظة'],
    ['workflows', 'Workflows', 'سير العمل'],
    ['mail', 'Mail', 'البريد'],
  ] },
  { id: 'administration', title: { en: 'Administration & Monitoring', ar: 'الإدارة والمراقبة' }, items: [
    ['settings', 'Settings', 'الإعدادات'],
    ['system-status', 'System status', 'حالة النظام'],
    ['logs', 'Logs', 'السجلات'],
    ['tasks', 'Tasks', 'المهام'],
    ['backup', 'Backup and restore', 'النسخ الاحتياطي والاستعادة'],
  ] },
  { id: 'advanced', title: { en: 'Optional & Advanced', ar: 'اختياري ومتقدّم' }, items: [
    ['ai', 'AI features', 'ميزات الذكاء الاصطناعي'],
    ['barcodes-asn', 'Barcodes and ASN', 'الباركود ورقم ASN'],
    ['consume-folder', 'The consume folder', 'مجلّد المعالجة'],
  ] },
]

// The guides index (docs/end-user-guides/index.md) is a single bilingual page:
// English first, then a "---" divider, then Arabic. Split it so the home page
// follows the same EN/AR toggle as every other guide.
function splitBilingual(md) {
  const body = md.replace(/^---\s*\r?\n[\s\S]*?\r?\n---\s*(?:\r?\n|$)/, '')
  const lines = body.split(/\r?\n/)
  const idx = lines.findIndex((l) => /^-{3,}\s*$/.test(l.trim()))
  if (idx === -1) return { en: body, ar: body }
  return {
    en: lines.slice(0, idx).join('\n').trimEnd() + '\n',
    ar: lines.slice(idx + 1).join('\n').trimEnd() + '\n',
  }
}

const homeMd = read(join(guidesDir, 'index.md'))
const home = { title: { en: 'User Guides', ar: 'أدلّة المستخدمين' }, ...splitBilingual(homeMd) }

const sections = SECTIONS.map((s) => ({
  id: s.id,
  title: s.title,
  items: s.items.map(([id, en, ar]) => {
    const fileEn = `${s.id}/${id}.md`
    const fileAr = `${s.id}/${id}.ar.md`
    return {
      id,
      title: { en, ar },
      fileEn,
      fileAr,
      en: read(join(guidesDir, fileEn)),
      ar: read(join(guidesDir, fileAr)),
    }
  }),
}))

const data = { title: home.title, home, sections }

const template = read(join(__dirname, 'docs-viewer.template.html'))
// Escape "</" so the JSON can never close the <script> tag it is embedded in.
const json = JSON.stringify(data).replace(/<\//g, '<\\/')
const html = template.replace('__GUIDES_DATA__', () => json)

const out = join(root, 'docs-viewer.html')
writeFileSync(out, html, 'utf8')

const guideCount = sections.reduce((n, s) => n + s.items.length, 0)
console.log(`Built ${out}`)
console.log(`  ${guideCount} guides (EN + AR) across ${sections.length} sections, plus the home index.`)
console.log(`  ${(Buffer.byteLength(html) / 1024).toFixed(1)} KB total.`)
