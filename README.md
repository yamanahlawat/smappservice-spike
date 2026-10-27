# SMAppService spike

Does `SMAppService.agent(plistName:)` register a bundled launch agent from an app that is
not signed with an Apple Developer ID?

The workflow builds a tiny app with one agent in `Contents/Library/LaunchAgents`, signs it
three ways, registers the agent on a GitHub macOS runner, and records the result:

- **adhoc:** `codesign --sign -`
- **selfsigned:** a self-signed code signing certificate the machine trusts
- **selfsigned-untrusted:** the same certificate after its trust is removed, which is what a
  user's Mac looks like

For each one the job summary shows the signature, the Gatekeeper verdict, what `register()`
returns, the status after five seconds, what `launchctl` holds, and whether the agent ran.

A runner can't log out and back in, so this doesn't show whether the agent starts at the
next login. Throwaway: it exists to answer one question for
[Banshee](https://github.com/yamanahlawat/banshee).
