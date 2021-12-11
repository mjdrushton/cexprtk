
REM Python 3.6
IF NOT exist venv-36 (
    py -3.6 -m venv venv-36
)

call venv-36\Scripts\activate
pip install --upgrade "setuptools>=38.6.0"
pip install wheel
pip wheel . -w wheelhouse
call venv-36\Scripts\deactivate

REM Python 3.7
IF NOT exist venv-37 (
    py -3.7 -mvenv venv-37
)

call venv-37\Scripts\activate
pip install --upgrade "setuptools>=38.6.0"
pip install wheel
pip wheel . -w wheelhouse
call venv-37\Scripts\deactivate

REM Python 3.8
IF NOT exist venv-38 (
    py -3.8 -mvenv venv-38
)

call venv-38\Scripts\activate
pip install --upgrade "setuptools>=38.6.0"
pip install wheel
pip wheel . -w wheelhouse
call venv-38\Scripts\deactivate


REM Python 3.9
IF NOT exist venv-39 (
    py -3.9 -mvenv venv-39
)

call venv-39\Scripts\activate
pip install --upgrade "setuptools>=38.6.0"
pip install wheel
pip wheel . -w wheelhouse
call venv-39\Scripts\deactivate

REM Python 3.10
IF NOT exist venv-310 (
    py -3.10 -mvenv venv-310
)

call venv-310\Scripts\activate
pip install --upgrade "setuptools>=38.6.0"
pip install wheel
pip wheel . -w wheelhouse
call venv-310\Scripts\deactivate

