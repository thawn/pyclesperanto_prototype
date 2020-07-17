import pyclesperanto_prototype as cle
import numpy as np
import pytest
import pyopencl as cl

from . import LINUX, CI


@pytest.mark.xfail('LINUX and CI', reason='INVALID_ARG_SIZE on CI', raises=cl.LogicError)
def test_paste():
    test1 = cle.push_zyx(np.asarray([
        [0, 0, 0, 1],
        [0, 0, 3, 1],
        [0, 0, 3, 1],
        [1, 1, 1, 1]
    ]))
    test2 = cle.push_zyx(np.asarray([
        [1, 2],
    ]))

    reference = cle.push_zyx(np.asarray([
        [0, 0, 0, 1],
        [0, 0, 3, 1],
        [0, 1, 2, 1],
        [1, 1, 1, 1]
    ]))

    result = cle.create(test1)
    cle.copy(test1, result)
    cle.paste(test2, result, 1, 2, 0)

    a = cle.pull(result)
    b = cle.pull(reference)
    print(a)

    assert (np.array_equal(a, b))
    print("ok paste")
