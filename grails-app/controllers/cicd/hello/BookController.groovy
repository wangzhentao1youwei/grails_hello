package cicd.hello

import grails.converters.JSON

class BookController {

    def index() {
        render ([version:2] as JSON)
    }
}
