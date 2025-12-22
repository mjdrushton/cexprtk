@REM Python 3.10
IF NOT exist venv-310 (
    py -3.10 -mvenv venv-310
)

call venv-310\Scripts\activate
python -m pip install --upgrade pip
pip install --upgrade "setuptools>=38.6.0"
pip install wheel
pip wheel . -w wheelhouse
call venv-310\Scripts\deactivate

IF NOT exist venv-311 (
    py -3.11 -mvenv venv-311
)

call venv-311\Scripts\activate
python -m pip install --upgrade pip
pip install --upgrade "setuptools>=38.6.0"
pip install wheel
pip wheel . -w wheelhouse
call venv-311\Scripts\deactivate


IF NOT exist venv-312 (
    py -3.12 -mvenv venv-312
)

call venv-312\Scripts\activate
python -m pip install --upgrade pip
pip install --upgrade "setuptools>=38.6.0"
pip install wheel
pip wheel . -w wheelhouse
call venv-312\Scripts\deactivate

IF NOT exist venv-313 (
    py -3.13 -mvenv venv-313
)

call venv-313\Scripts\activate
python -m pip install --upgrade pip
pip install --upgrade "setuptools>=38.6.0"
pip install wheel
pip wheel . -w wheelhouse
call venv-313\Scripts\deactivate

IF NOT exist venv-314 (
    py -3.14 -mvenv venv-314
)

call venv-314\Scripts\activate
python -m pip install --upgrade pip
pip install --upgrade "setuptools>=38.6.0"
pip install wheel
pip wheel . -w wheelhouse
call venv-314\Scripts\deactivate


@REM Test the wheels

call venv-310\Scripts\activate
pip uninstall -y cexprtk
pip install pytest
pip install wheelhouse\cexprtk-0.4.2-cp310-cp310-win_amd64.whl
python -mpytest tests
call venv-310\Scripts\deactivate

call venv-311\Scripts\activate
pip uninstall -y cexprtk
pip install pytest
pip install wheelhouse\cexprtk-0.4.2-cp311-cp311-win_amd64.whl
python -mpytest tests
call venv-311\Scripts\deactivate

call venv-312\Scripts\activate
pip uninstall -y cexprtk
pip install pytest
pip install wheelhouse\cexprtk-0.4.2-cp312-cp312-win_amd64.whl
python -mpytest tests
call venv-312\Scripts\deactivate

call venv-313\Scripts\activate
pip uninstall -y cexprtk
pip install pytest
pip install wheelhouse\cexprtk-0.4.2-cp313-cp313-win_amd64.whl
python -mpytest tests
call venv-313\Scripts\deactivate

call venv-314\Scripts\activate
pip uninstall -y cexprtk
pip install pytest
pip install wheelhouse\cexprtk-0.4.2-cp314-cp314-win_amd64.whl
python -mpytest tests
call venv-314\Scripts\deactivate