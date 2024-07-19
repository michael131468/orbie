#!/usr/bin/env python3

from example.example_a import sibling
from example.example_a.children import child
from example.example_a.children.grandchildren import grandchild
from example.example_shared import shared

def example_a_only_function() -> None:
    sibling.sibling_function()
    child.child_function()
    grandchild.grandchild_function()
    shared.shared_function()

if __name__ == "__main__":
    print("helloworld!")
