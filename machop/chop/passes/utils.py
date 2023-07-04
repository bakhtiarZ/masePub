import inspect
import re
from typing import Tuple

import torch


def check_func_type(node, my_func):
    return type(node.target) == type(my_func)


def check_func(node, my_func):
    return node.target == my_func


def isinstance_but_not_subclass(my_object, my_class):
    return my_object.__class__ is my_class


def match_a_pattern(name: str, patterns: list[str]) -> str | None:
    for pattern in patterns:
        match = re.fullmatch(pattern, name)
        if match:
            return pattern
    return None


def get_parent_name(target: str) -> Tuple[str, str]:
    """
    Splits a qualname into parent path and last atom.
    For example, `foo.bar.baz` -> (`foo.bar`, `baz`)
    """
    *parent, name = target.rsplit(".", 1)
    return parent[0] if parent else "", name


def get_module_by_name(model, request_name):
    for name, layer in model.named_modules():
        if name == request_name:
            return layer
    return None


def get_module_by_target(model, target):
    target_atoms = target.split(".")
    attr_itr = model
    for i, atom in enumerate(target_atoms):
        if not hasattr(attr_itr, atom):
            raise RuntimeError(
                f"Node referenced nonexistent target {'.'.join(target_atoms[:i])}"
            )
        attr_itr = getattr(attr_itr, atom)
    return attr_itr


def get_node_by_name(graph, request_name):
    for node in graph.nodes:
        if node.name == request_name:
            return node
    raise RuntimeError(f"No node named {request_name} found in graph")


# Verilog format
# Format to a compatible verilog name
def vf(string):
    return string.replace(".", "_").replace(" ", "_")


def v2p(string):
    """
    Variable to Parameter
    """
    return string.upper().replace("DATA_", "")


def get_input_index(node, next_node):
    """
    Get the arg index of the next_node for node
    """
    arg_count = len(next_node.all_input_nodes)
    for i in range(0, arg_count):
        if (
            next_node.meta["mase"].parameters["common"]["args"][f"data_in_{i}"]["from"]
            == node
        ):
            return i


def get_mase_op(node):
    return node.meta["mase"].parameters["common"]["mase_op"]


def get_mase_type(node):
    return node.meta["mase"].parameters["common"]["mase_type"]


def node_actual_target(node):
    """
    return the actual target of the node
    - for "call_module": return the torch.nn.Module instance
    - for "call_function": return the function
    - for others: return the node.target
    """
    if node.op == "call_module":
        return node.meta["mase"].module
    elif node.op == "call_function":
        return node.target
    else:
        return node.target
