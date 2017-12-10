from ._exceptions import VariableNameShadowException, ReservedFunctionShadowException, ParseException, BadVariableException, UnknownSymbolResolverException
from ._cexprtk import USRSymbolType
from ._cexprtk import evaluate_expression, check_expression
from ._cexprtk import Expression
from ._symbol_table import Symbol_Table

from . import _custom_function_callbacks

# from . import tests