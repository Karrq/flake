## Description

[Nest](https://github.com/nestjs/nest) framework template repository, configured via pnpm, packed and compiled via bytenode and managed by [Nix](https://github.com/NixOs/nix).

## Copy the template

``` bash
$ nix init -t http://github.com/Karrq/nestjs-template --impure
```

## Installation

Load the environment via nix-shell, installing required programs and packages (excluding docker)

```bash
$ nix shell
```

## Building the app

Output will be at `result/`

### Production build

``` bash
$ nix build .#app
```

To run use `node result/main.js`

### Docker image

Will use the production build, output is `result`

``` bash
$ nix build .#docker
```

To run, first load the image, then run:

``` bash
$ docker load < result
$ docker run nestjs-template:0.0.1
```
