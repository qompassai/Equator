use std::fmt::Display;

use crate::{
    fusion::kernel::AutotunableKernel, tune::anchor, tune_key::JitAutotuneKey, JitRuntime,
};
use cubecl::tune::{AutotuneOperation, AutotuneOperationSet};
use serde::{Deserialize, Serialize};

#[derive(new)]
pub struct ElementWiseAutotuneOperationSet<R: JitRuntime> {
    key: JitAutotuneKey,
    kernel_1: AutotunableKernel<R>,
    kernel_2: AutotunableKernel<R>,
    kernel_default: AutotunableKernel<R>,
}

#[derive(Hash, Eq, PartialEq, Debug, Clone, Serialize, Deserialize)]
/// Autotune key representative of a fused element wise kernel.
pub struct FusionElemWiseAutotuneKey {
    anchored_num_operations: usize,
    anchored_shape: Vec<usize>,
}

impl Display for FusionElemWiseAutotuneKey {
    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
        f.write_str(
            format!(
                "Fusion ElemWise - num_operations: {:?} shape: {:?}",
                self.anchored_num_operations, self.anchored_shape
            )
            .as_str(),
        )
    }
}

impl<R: JitRuntime> AutotuneOperationSet<JitAutotuneKey> for ElementWiseAutotuneOperationSet<R> {
    fn key(&self) -> JitAutotuneKey {
        self.key.clone()
    }

    fn autotunables(&self) -> Vec<Box<dyn cubecl::tune::AutotuneOperation>> {
        let kernel_1: Box<dyn AutotuneOperation> = self.kernel_1.clone();
        let kernel_2: Box<dyn AutotuneOperation> = self.kernel_2.clone();

        vec![kernel_1, kernel_2]
    }

    fn fastest(self: Box<Self>, _: usize) -> Box<dyn AutotuneOperation> {
        Box::new(self.kernel_default)
    }
}

impl FusionElemWiseAutotuneKey {
    /// Create a fused element wise autotune key.
    pub fn new(num_operations: usize, shape: &[usize]) -> Self {
        Self {
            anchored_shape: shape.iter().map(|x| anchor(*x, Some(4096))).collect(),
            anchored_num_operations: anchor(num_operations, None),
        }
    }
}
