REM Python 2.7
IF NOT exist venv-27 (
    pip2.7 install --user --upgrade pip
    pip2.7 install --user virtualenv
    virtualenv -p c:\python27\python.exe venv-27
)

call venv-27\Scripts\activate
pip install --upgrade setuptools>=38.6.0
pip install wheel
pip wheel . -w wheelhouse
call venv-27\Scripts\deactivate


REM Python 2.7 32 bit
IF NOT exist venv-27-32 (
    pip2.7 install --user --upgrade pip
    pip2.7 install --user virtualenv
    virtualenv -p c:\python27-32\python.exe venv-27-32
)

call venv-27-32\Scripts\activate
pip install --upgrade setuptools>=38.6.0
pip install wheel
pip wheel . -w wheelhouse
call venv-27-32\Scripts\deactivate


REM REM Python 3.5
IF NOT exist venv-35 (
    virtualenv -p "%USERPROFILE%\AppData\Local\Programs\Python\Python35\python.exe" venv-35
)

call venv-35\Scripts\activate
pip install --upgrade setuptools>=38.6.0
pip install wheel
pip wheel . -w wheelhouse
call venv-35\Scripts\deactivate


REM Python 3.6
IF NOT exist venv-36 (
    virtualenv -p "%USERPROFILE%\AppData\Local\Programs\Python\Python36\python.exe" venv-36
)

call venv-36\Scripts\activate
pip install --upgrade setuptools>=38.6.0
pip install wheel
pip wheel . -w wheelhouse
call venv-36\Scripts\deactivate


REM Python 3.6 32 bit
IF NOT exist venv-36-32 (
    virtualenv -p "%USERPROFILE%\AppData\Local\Programs\Python\Python36-32\python.exe" venv-36-32
)

call venv-36-32\Scripts\activate
pip install --upgrade setuptools>=38.6.0
pip install wheel
pip wheel . -w wheelhouse
call venv-36-32\Scripts\deactivate


REM Python 3.7
IF NOT exist venv-37 (
    virtualenv -p "%USERPROFILE%\AppData\Local\Programs\Python\Python37\python.exe" venv-37
)

call venv-37\Scripts\activate
pip install --upgrade setuptools>=38.6.0
pip install wheel
pip wheel . -w wheelhouse
call venv-37\Scripts\deactivate

REM Python 3.7 32 bit
IF NOT exist venv-37-32 (
    virtualenv -p "%USERPROFILE%\AppData\Local\Programs\Python\Python37-32\python.exe" venv-37-32
)

call venv-37-32\Scripts\activate
pip install --upgrade setuptools>=38.6.0
pip install wheel
pip wheel . -w wheelhouse
call venv-37-32\Scripts\deactivate


REM Python 3.8
IF NOT exist venv-38 (
    virtualenv -p "c:\Python38\python.exe" venv-38
)

call venv-38\Scripts\activate
pip install --upgrade setuptools>=38.6.0
pip install wheel
pip wheel . -w wheelhouse
call venv-38\Scripts\deactivate


REM Python 3.8 32 bit
IF NOT exist venv-38-32 (
    virtualenv -p "%USERPROFILE%\AppData\Local\Programs\Python\Python38-32\python.exe" venv-38-32
)

call venv-38-32\Scripts\activate
pip install --upgrade setuptools>=38.6.0
pip install wheel
pip wheel . -w wheelhouse
call venv-38-32\Scripts\deactivate

