import { application } from "../application"

const modules = import.meta.globEager("./**/*_controller.js")

for (const path in modules) {
  const identifier = path
    .split("/")
    .pop()
    .replace("_controller.js", "")
    .replace("_", "-")

  application.register(identifier, modules[path].default)
}
