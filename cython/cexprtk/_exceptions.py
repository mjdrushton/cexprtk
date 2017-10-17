class BadVariableException(Exception):
  pass

class NameShadowException(Exception):
  pass

class VariableNameShadowException(NameShadowException):
  pass

class ReservedFunctionShadowException(NameShadowException):
  pass

class ParseException(Exception):
  pass

class UnknownSymbolResolverException(Exception):
  pass