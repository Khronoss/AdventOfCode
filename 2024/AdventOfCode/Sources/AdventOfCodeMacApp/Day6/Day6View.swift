//
//  SwiftUIView.swift
//  AdventOfCode
//
//  Created by Anthony MERLE on 10/12/2024.
//

import SwiftUI
import SpriteKit

class Day6Scene: SKScene {
    var map: Day6Model.Map
    let cellSize = 10

    var guardNode: SKSpriteNode!

    init(map: Day6Model.Map) {
        self.map = map

        super.init(
            size: CGSize(
                width: map.size.width * cellSize,
                height: map.size.height * cellSize
            )
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        drawMap()

        self.guardNode = addNode(
            color: .green,
            at: map.guardState.position
        )
    }

//    override func update(_ currentTime: TimeInterval) {
//        step()
//    }

    private func drawMap() {
        for y in (0..<map.size.height) {
            for x in (0..<map.size.width) {
                let position = Day6Model.Position(x: x, y: y)
                let color: NSColor = map
                    .isObstacle(position) ?
                    .red : .blue

                addNode(
                    color: color,
                    at: position
                )
            }
        }

        //        for cell in map.visitedCells {
        //            context.fill(
        //                Path(cellRect(at: cell.position)),
        //                with: .color(.white.opacity(0.3))
        //            )
        //        }
    }

    func step() {
        if let cell = map.visitedCells.last {
            addNode(
                color: .init(white: 1, alpha: 0.3),
                at: cell.position
            )
        }

        Day6Model.move(
            guardState: &map.guardState,
            visitedCells: &map.visitedCells,
            in: map
        )

        guardNode.position = map.guardState.position
            .scaled(by: cellSize)
            .toCGPoint

    }

    @discardableResult
    private func addNode(
        color: NSColor,
        at position: Day6Model.Position
    ) -> SKSpriteNode {
        let node = SKSpriteNode(
            color: color,
            size: CGSize(width: cellSize - 1, height: cellSize - 1)
        )
        node.anchorPoint = .zero
        node.position = position
            .scaled(by: cellSize)
            .toCGPoint
        addChild(node)
        return node
    }
}

struct Day6View: View {
    @Bindable var model = Day6Model()

    let cellSize = 10

    var body: some View {
        VStack {
            HStack {
                Button("Step") {
                    print("Step")
                    model.step()
                }

                Button("Start") {
                    print("Sart")

                }

                Spacer()
            }

            if let map = model.map {
                SpriteView(scene: Day6Scene(map: map))
//                Canvas { context, size in
//                    drawMap(map, context: context, size: size)
//                }
                .frame(
                    width: CGFloat(map.size.width * cellSize),
                    height: CGFloat(map.size.height * cellSize)
                )
            }
        }
        .padding()
        .onAppear {
            model.setup()
        }
    }
}

#Preview {
    Day6View()
}

extension Day6Model.Position {
    var toCGPoint: CGPoint {
        CGPoint(x: x, y: y)
    }
}
