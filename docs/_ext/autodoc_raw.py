from sphinx.ext import autodoc

class SimpleDocumenter(autodoc.MethodDocumenter):
    """
    http://stackoverflow.com/questions/7825263/including-docstring-in-sphinx-documentation
    """
    objtype = "simple"

    #do not indent the content
    content_indent = ""

    #do not add a header to the docstring
    def add_directive_header(self, sig):
        pass

def setup(app):
    app.add_autodocumenter(SimpleDocumenter)
