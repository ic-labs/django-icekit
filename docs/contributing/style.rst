Code and commit style
---------------------

Git branching
=============

We are using the
`Gitflow <http://nvie.com/posts/a-successful-git-branching-model/>`__
branching model. Basically:

-  The ``master`` branch contains stable code, and each commit
   represents a tagged release.
-  The ``develop`` branch is an integration branch for new features, and
   is merged into ``master`` when we are ready to tag a new release.
-  New features are developed in ``feature/*`` branches. Create a pull
   request when you are ready to merge a feature branch back into
   ``develop``.

The `SourceTree <http://sourcetreeapp.com/>`__ app (OS X and Windows)
has built-in support for Gitflow, and there is also a collection of
`git-extensions <https://github.com/nvie/gitflow/>`__ for command line
users.

Code style
==========

It's important that we adopt a consistent code style to minimise code
churn and make collaboration easier.

-  Follow `PEP8 <http://legacy.python.org/dev/peps/pep-0008/>`__ for
   Python code, unless there is a good reason not to.
-  Install the `EditorConfig <http://editorconfig.org/>`__ plugin for
   your preferred code editor. ICEkit comes with an ``.editorconfig`` file which
   indicates which formatting defaults to use for different file types.


