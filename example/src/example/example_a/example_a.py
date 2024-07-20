#!/usr/bin/env python3

from example.example_a import sibling
from example.example_a.nephews import nephew
from example.example_shared import shared

def example_a_only_function() -> None:
    sibling.sibling_one()
    nephew.nephew()
    shared.shared_function()
