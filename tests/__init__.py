def suite():
  import unittest
  from . import test_cexprtk
  return unittest.TestLoader().loadTestsFromModule(test_cexprtk)
