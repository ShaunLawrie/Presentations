// Allow this Codespace's authenticated forwarded URL through Vite's host check.
const codespaceHost = process.env.CODESPACE_NAME && process.env.GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN
  ? `${process.env.CODESPACE_NAME}-3030.${process.env.GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}`
  : undefined

export default {
  server: {
    allowedHosts: codespaceHost ? [codespaceHost] : [],
  },
}
