def suite():
  import unittest
  import test_cexprtk
  return unittest.TestLoader().loadTestsFromModule(test_cexprtk)
