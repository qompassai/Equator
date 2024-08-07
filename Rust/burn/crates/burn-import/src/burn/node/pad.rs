use std::str::FromStr;

use super::{Node, NodeCodegen};
use crate::burn::{Scope, TensorType, ToTokens, Type};
use burn::config::Config;
use burn::record::PrecisionSettings;
use proc_macro2::TokenStream;
use quote::quote;

#[derive(Config, Debug)]
pub struct PadConfig {
    pub pads: Vec<usize>,
    pub constant_value: f32,
}

#[derive(Debug, Clone, new)]
pub struct PadNode {
    pub input: TensorType,
    pub output: TensorType,
    pub config: PadConfig,
}

impl<PS: PrecisionSettings> NodeCodegen<PS> for PadNode {
    fn output_types(&self) -> Vec<Type> {
        vec![Type::Tensor(self.output.clone())]
    }
    fn input_types(&self) -> Vec<Type> {
        vec![Type::Tensor(self.input.clone())]
    }
    fn forward(&self, scope: &mut Scope, node_position: usize) -> TokenStream {
        let input = scope.tensor_use_owned(&self.input, node_position);
        let output = &self.output.name;

        let pads = self.config.pads.iter().map(|p| p.to_tokens());
        let constant_value_string = format!("{}_f32.elem()", self.config.constant_value);
        let constant_value = TokenStream::from_str(&constant_value_string).unwrap();

        quote! {
            let #output = #input.pad((#(#pads),*), #constant_value);
        }
    }
    fn into_node(self) -> Node<PS> {
        Node::Pad(self)
    }

    fn register_imports(&self, imports: &mut crate::burn::BurnImports) {
        imports.register("burn::tensor::ElementConversion");
    }
}

#[cfg(test)]
mod tests {
    use burn::record::FullPrecisionSettings;

    use super::*;
    use crate::burn::{
        graph::BurnGraph,
        node::{pad::PadNode, test::assert_tokens},
        TensorType,
    };

    #[test]
    fn test_codegen_pad() {
        let mut graph = BurnGraph::<FullPrecisionSettings>::default();
        let config = PadConfig::new(vec![1, 2, 3, 4], -1.0);
        graph.register(PadNode::new(
            TensorType::new_float("input", 2),
            TensorType::new_float("output", 2),
            config,
        ));
        graph.register_input_output(vec!["input".to_string()], vec!["output".to_string()]);

        let expected = quote! {
            use burn::tensor::ElementConversion;
            use burn::{
                module::Module,
                tensor::{backend::Backend, Tensor},
            };

            #[derive(Module, Debug)]
            pub struct Model<B: Backend> {
                phantom: core::marker::PhantomData<B>,
                device: burn::module::Ignored<B::Device>,
            }

            impl<B: Backend> Model <B> {
                #[allow(unused_variables)]
                pub fn new(device: &B::Device) -> Self {
                    Self {
                        phantom: core::marker::PhantomData,
                        device: burn::module::Ignored(device.clone()),
                    }
                }
                #[allow(clippy::let_and_return, clippy::approx_constant)]
                pub fn forward(&self, input: Tensor<B, 2>) -> Tensor<B, 2> {
                    let output = input.pad((1, 2, 3, 4), -1_f32.elem());
                    output
                }
            }
        };

        assert_tokens(graph.codegen(), expected);
    }
}
