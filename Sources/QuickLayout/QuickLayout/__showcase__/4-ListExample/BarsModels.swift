/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

struct BarModel {
  let coverImage: UIImage
  let name: String
  let locationName: String
  let description: String
  let shareURL: URL
}
#if compiler(>=6.1)
nonisolated extension BarModel: Hashable {}
#else
extension BarModel: Hashable {}
#endif

// swiftlint:disable force_unwrapping
actor BarsStore {
  static let entries = {
    return [
      BarModel(coverImage: UIImage(named: "1_handshake")!, name: "Handshake", locationName: "🇲🇽 Mexico City", description: "Hidden behind an enigmatic black door in Colonia Juarez, whose only sign is the number '13', lies Handshake Speakeasy. Copper arches frame the backbar and the long, marble counter sits in front like an altar to the cocktail. The devil is in the detail here: in the branded silver fixtures, the seriously smart mini-cocktail serves and the cooling system under the bar that ensures every glass stays frosty.", shareURL: URL(string: "https://www.instagram.com/handshake_bar")!),
      BarModel(coverImage: UIImage(named: "2_superbueno")!, name: "Superbueno", locationName: "🇺🇸 New York City", description: "Superbueno is a perfectly named bar. The bilingual explanation perfectly encapsulates the zeitgeist of this vibrant ode to Mexican-American culture. Industry veteran Ignacio ‘Nacho’ Jimenez collaborated with power publican Greg Boehm (Katana Kitten, Mace) to open an elevated cantina on New York City’s Lower East Side. Together, the power duo has created a festive environment buzzing with a diverse crowd from early afternoon opening through to late-night close. ", shareURL: URL(string: "https://www.instagram.com/superbuenonyc/")!),
      BarModel(coverImage: UIImage(named: "3_overstory")!, name: "Overstory", locationName: "🇺🇸 New York City", description: "A spectacular view of the New York City skyline serves as backdrop for Overstory, where the cocktail magic served up is just as memorable as the vistas beyond. Located on the 64th floor of historic Financial District building 70 Pine Street, the experience begins in the grand lobby of the art deco building, where guests are welcomed and escorted via elevator to the petite jewel box of a bar. There, an expansive wraparound terrace offers guests the chance to soak in the glittering energy of the city before (or after) settling in for cocktail service.", shareURL: URL(string: "https://www.instagram.com/overstory")!),
      BarModel(coverImage: UIImage(named: "4_martiny")!, name: "Martiny's", locationName: "🇺🇸 New York City", description: "Takuma Watanabe earned a devout following helming the bar program at New York City’s legendary Angel’s Share. After the beloved speakeasy closed, Watanabe opened Martiny’s, an homage to the drinking cultures of his Tokyo birthplace as well as his Manhattan home. Occupying a carriage house in Gramercy, once owned by artist Philip Martiny, the three-storey lounge is a temple to luxury.", shareURL: URL(string: "https://www.instagram.com/martinys_nyc")!),
    ]
  }()
}
