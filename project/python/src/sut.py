class ProductionServer(object):
    def serve(self, request):
        if request == "beer":
            return True

        return False
