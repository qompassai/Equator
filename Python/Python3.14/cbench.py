#!/usr/bin/env python3
import pyperf

runner = pyperf.Runner()
runner.timeit(name="sort a sorted list",
              stmt="sorted(s, key=f)",
              setup="f = lambda x: x; s = list(range(1000))")
