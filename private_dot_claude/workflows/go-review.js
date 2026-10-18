export const meta = {
  name: 'go-review',
  description: '5 parallel Go reviewers (security, safety, performance, concurrency, naming) over a diff',
  phases: [{ title: 'Review' }],
}

const FINDINGS_SCHEMA = {
  type: 'object',
  properties: {
    findings: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          file: { type: 'string' },
          line: { type: 'number' },
          severity: { type: 'string', enum: ['low', 'medium', 'high'] },
          summary: { type: 'string' },
        },
        required: ['file', 'summary'],
      },
    },
  },
  required: ['findings'],
}

const base = args && args.base ? args.base : 'main'

const DIMENSIONS = [
  { key: 'security', prompt: `Review the diff since ${base} for Go security issues - injection, crypto, path traversal, secrets, SSRF. Use the golang-security skill's checklist. Report concrete findings only, each with file, line, severity, summary.` },
  { key: 'safety', prompt: `Review the diff since ${base} for Go safety bugs - nil panics, typed-nil interfaces, append aliasing, numeric truncation, defer-in-loop. Use the golang-safety skill's checklist. Report concrete findings only, each with file, line, severity, summary.` },
  { key: 'performance', prompt: `Review the diff since ${base} for Go performance issues - unnecessary allocations, hot-path inefficiency, missed pooling/caching opportunities. Use the golang-performance skill's patterns. Report concrete findings only, each with file, line, severity, summary.` },
  { key: 'concurrency', prompt: `Review the diff since ${base} for Go concurrency issues - goroutine leaks, race conditions, channel misuse, missing sync primitives. Use the golang-concurrency skill's checklist. Report concrete findings only, each with file, line, severity, summary.` },
  { key: 'naming', prompt: `Review the diff since ${base} for Go naming convention violations - packages, constructors, interfaces, errors, booleans, receivers. Use the golang-naming skill's conventions. Report concrete findings only, each with file, line, severity, summary.` },
]

phase('Review')
const results = await parallel(
  DIMENSIONS.map(d => () =>
    agent(d.prompt, { label: `review:${d.key}`, phase: 'Review', schema: FINDINGS_SCHEMA })
      .then(r => (r ? r.findings.map(f => ({ ...f, dimension: d.key })) : []))
  )
)

const severityRank = { high: 0, medium: 1, low: 2 }
const merged = results
  .flat()
  .sort((a, b) => (severityRank[a.severity] ?? 3) - (severityRank[b.severity] ?? 3))

log(`${merged.length} findings across ${DIMENSIONS.length} dimensions`)
return merged
