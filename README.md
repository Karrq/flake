# My-nix collection

This repo contains packages, utilities, templates and other such things that at some point in time I made use of and I was able to share with the community.

PRs are welcome but there should be no expectation on support or maintenance

## Templates

### NestJS

This template mimics the `nest init` command, using `pnpm` and adding the following:

1. A derivation to build the nestjs project
2. A derivation to containerize the application
3. A devShell with all required dependencies

### Clojure

This template allows quick scaffolding of a clojure application, including:

1. A derivation to build the clojure project
2. A derivation to containerize the application
3. A devShell with all required dependencies
