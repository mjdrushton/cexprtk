REM Python 2.7
IF NOT exist venv-27 (
    pip2.7 install --upgrade pip
    pip2.7 install virtualenv
    virtualenv -p c:\python27\python.exe venv-27
)

call venv-27\Scripts\activate
pip install wheel nose
pip wheel . -w wheelhouse
call venv-27\Scripts\deactivate

REM Python 3.6
IF NOT exist venv-36 (
    virtualenv -p "c:\Program Files\Python36\python.exe" venv-36
)

call venv-36\Scripts\activate
pip install wheel nose
pip wheel . -w wheelhouse
call venv-36\Scripts\deactivate

REM Python 3.5
IF NOT exist venv-35 (
    virtualenv -p "%USERPROFILE%\AppData\Local\Programs\Python\Python35\python.exe" venv-35
)

call venv-35\Scripts\activate
pip install wheel nose
pip wheel . -w wheelhouse
call venv-35\Scripts\deactivate

REM Python 3.7
IF NOT exist venv-37 (
    virtualenv -p "%USERPROFILE%\AppData\Local\Programs\Python\Python37\python.exe" venv-37
)

call venv-37\Scripts\activate
pip install wheel nose
pip wheel . -w wheelhouse
call venv-37\Scripts\deactivate


REM Tests
call venv-27\Scripts\activate
pip -v install cexprtk --no-cache-dir --no-index -f wheelhouse
nosetests cexprtk
call venv-27\Scripts\deactivate

call venv-35\Scripts\activate
pip -v install cexprtk --no-cache-dir --no-index -f wheelhouse
nosetests cexprtk
call venv-35\Scripts\deactivate

call venv-36\Scripts\activate
pip -v install cexprtk --no-cache-dir --no-index -f wheelhouse
nosetests cexprtk
call venv-36\Scripts\deactivate

call venv-37\Scripts\activate
pip -v install cexprtk --no-cache-dir --no-index -f wheelhouse
nosetests cexprtk
call venv-37\Scripts\deactivate

