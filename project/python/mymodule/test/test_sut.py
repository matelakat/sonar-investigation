import unittest
from mymodule import sut


class SomeTest(unittest.TestCase):
    def test_something(self):
        self.assertTrue(False)

    def test_some_stupid_method(self):
        server = sut.ProductionServer()

        self.assertEquals("K", server.uppercase("k"))

