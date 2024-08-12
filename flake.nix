{
  description = "My templates";

  outputs = {...}: {
    templates = {
      nestjs = {
        path = ./templates/nestjs;
        description = "Nix NestJS template w/ pnpm and docker";
      };
    };
  };
}
