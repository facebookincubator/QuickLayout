/**
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

/**
 * Creating a sidebar enables you to:
 - create an ordered group of docs
 - render a sidebar for each doc of that group
 - provide next/previous navigation

 The sidebars can be generated from the filesystem, or explicitly defined here.

 Create as many sidebars as you want.
 */

module.exports = {

  // But you can create a sidebar manually
  docs: [
    'intro',
    'quickstart',
    'code-samples',
    ,
    {
      '@QuickLayout Macro': [
        'how-to-use/macro-layout-integration',
        'how-to-use/macro-layout-integration-state-updates',
        'how-to-use/macro-layout-integration-bodyContainerView',
        'how-to-use/macro-layout-integration-isBodyEnabled',
        'how-to-use/macro-layout-integration-dos',
        'how-to-use/macro-layout-integration-donts',
      ]
    },
    'how-to-use/manual-layout-integration',
    'how-to-use/manual-layout-integration-uiviewcontrollers',
    {
      'Containers': [
        'layout/hstack',
        'layout/vstack',
        'layout/zstack',
        'layout/hflow',
        'layout/vflow',
        'layout/grid',
      ]
    },
    {
      'Modifiers': [
        'layout/padding',
        'layout/fixed-frame',
        'layout/flexible-frame',
        'layout/constrained-size',
        'layout/resizable',
        'layout/expandable',
        'layout/offset',
        'layout/aspect-ratio',
        'layout/overlay',
        'layout/background',
        'layout/layout-priority',
        'layout/layout-direction',
        'layout/fixed-size',
        'layout/ideal-layout',
        'layout/custom-alignments',
        'layout/alignment-guides',
      ]
    },
    {
      'Control Flows': [
        'layout/if-else',
        'layout/for-loops',
        'layout/foreach',
      ]
    },
    {
      'Miscellaneous': [
        'layout/empty-layout',
        'lazy-views',
      ]
    },
    {
      'Concepts': [
        'concepts/layout-trees',
        'concepts/proposed-size',
        'concepts/flexibilities',
        'concepts/double-measurement',
        'concepts/thread-safety',
      ]
    }
  ],
};
