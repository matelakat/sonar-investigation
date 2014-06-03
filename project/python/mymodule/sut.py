class ProductionServer(object):
    def __init__(self):
        self.state = "START"

    def serve(self, request):
        if request == "beer":
            return True

        return False

    def uppercase(self, text):
        return text.upper()

    def some_stupid_method(self):
        if variable is True:
            return False


    def complicated_function(self):
        if "START" == self.state:
            self.state = "WORKING"
        elif "WORKING" == self.state:
            self.state = "DONE"
