// app/javascript/application.js
import "@hotwired/turbo-rails"
import { Application } from "@hotwired/establish"
import "./controllers"

const application = Application.start()
application.debug = false
window.Stimulus = application

export { application }
