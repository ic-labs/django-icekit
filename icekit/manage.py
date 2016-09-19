# This file is here to trick django-supervisor into finding its config file.

# Blow up with an explanation if someone tries to use this dummy script
if __name__ == "__main__":
    import os
    raise Exception(
        "%s is a placeholder manage.py script, not a real one. Run %s instead."
        % (os.path.abspath(__file__),
           os.path.abspath(
                os.path.join(os.path.basename(__file__), 'bin', 'manage.py'))))
