//
//  GridFiller.swift
//  ezlang
//
//  Created by mac on 08.03.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import Foundation
import SpriteKit

typealias GridPoint = (x:Int, y:Int)

class Grid {

    internal static let EmptyCell: Character = " "[0];

    var charGrid: Array2D<Character> = Array2D<Character>(rows: 5, columns: 5, item: EmptyCell)
    var size: GridSize?
    var difficulty: Difficulty?
    var levelsCount: Int = 0;
    var solvedCount: Int = 0;
    var groupName: Int = 0;

    init(size: GridSize) {
        self.size = size
        let (r, c) = size.getSize()
        charGrid = Array2D<Character>(rows: r, columns: c, item: Grid.EmptyCell)
    }

    
    convenience init(task: Task, size: GridSize, difficulty: Difficulty, direction: TranslationDirection, levelType: LevelType){
        self.init(size: size)
        let translation = task.getWord(direction) as String!
        var transalts: [String] = task.getAlternatives(direction)
        NSLog("answer:\(translation)")

        GridFiller.fillWord(translation.uppercaseString, field: &charGrid);
        NSLog("**************")
        NSLog(charGrid.toString())
        NSLog("**************")

        switch (difficulty.getWrongCount()) {
        case 0:
            break;
        case 1:
            if (transalts.count > 0) {
                GridFiller.fillWord(transalts[0].uppercaseString, field: &charGrid);
                NSLog(charGrid.toString())
                NSLog("**************")
            }
            break;
        case 2:
            for i in 0 ... (transalts.count > 2 ? 3 : transalts.count) {
                GridFiller.fillWord(transalts[i].uppercaseString, field: &charGrid);
                NSLog(charGrid.toString())
            }
            break;
        case 3:
            for i in 0 ... (transalts.count > 2 ? 3 : transalts.count) {
                GridFiller.fillWord(transalts[i].uppercaseString, field: &charGrid);
                NSLog(charGrid.toString())
                NSLog("**************")
            }
            break;
        case 4:
            for i in 0 ... transalts.count {
                GridFiller.fillWord(transalts[i].uppercaseString , field: &charGrid);
                NSLog(charGrid.toString())
                NSLog("**************")
            }
            break;
        default:
            return;
        }

        GridFiller.fillRandom(&charGrid, direction: direction, type: levelType);
        NSLog(charGrid.toString())
        NSLog("**************")

    }

    func getLetterNodes() -> Set<LetterNode> {
        var nodes = Set<LetterNode>()
        if let sz = size as GridSize! {
            for i in 0 ... sz.getSize().rows - 1{
                for j in 0 ... sz.getSize().columns - 1{
                    var nodeSize = size?.getSize().rows == 5 ? CGFloat(70) : CGFloat(40)
                    let node = LetterNode(row: i, column: j,size:nodeSize, character: charGrid[i, j])
                    node.position = fromPoint(j, column: i,size: sz.getSize().rows)
                    nodes.insert(node)
                }
            }
        }
        return nodes
    }
}

class GridFiller {


    static func fillWord(word: String, inout field: Array2D<Character>) {
        let wordLen = word.characters.count;
        if (field.count {$0 == Grid.EmptyCell} > wordLen && word.characters.count > 0) {
            var done = false;
            let size = field.rows;
            var _field: Array2D<Character> = Array2D<Character>(rows: size, columns: size,item:Grid.EmptyCell)
            for _ in 0 ... 99{
                if(done) {
                    for i in 0 ... size - 1 {
                        field[i] = _field[i]
                    }
                    return;
                }
                for i in 0 ... size - 1{
                    _field[i] = field[i]
                }

                var way: Array<GridPoint> = Array<GridPoint>();
                for i:Int in 0 ... wordLen - 1 {
                    let p: GridPoint? = findPlaceForLetter(word[i], way:way,field: _field);
                    if(p == nil){
                        break;
                    }
                    way.append(p!);
                    _field[p!.x, p!.y] = word[i]
                    if (i == wordLen - 1) {
                        done = true;
                    }
                }
            }
        }
    }


    static func findPlaceForLetter(letter: Character, way: [GridPoint], field: Array2D<Character>) -> GridPoint? {
        let size = field.rows

        if (way.count == 0) {
            var p: GridPoint
            var posI1: Int, posI2: Int;
            repeat {
                posI1 = Int(arc4random_uniform(UInt32(size)))
                posI2 = Int(arc4random_uniform(UInt32(size)))
                p = (posI1, posI2)
            } while (!(field[p.x, p.y] == Grid.EmptyCell || field[p.x, p.y] == letter));
            return p;
        } else {
            let p1: GridPoint = way[way.count - 1];
            var free = [GridPoint]();
            for i in -1 ... 1 {
                for j in -1 ... 1 {
                    if (
                    !(p1.x + i < 0 ||
                            p1.x + i > size - 1 ||
                            p1.y + j < 0 ||
                            p1.y + j > size - 1)) {
                        if (!way.contains{$0 == (p1.x + i, p1.y + j)}) {
                            if (field[p1.x + i, p1.y + j] == letter || field[p1.x + i, p1.y + j] == Grid.EmptyCell) {
                                free.append((p1.x + i, p1.y + j));
                            }
                        }
                    }
                }
            }
            let randomIndex = Int(arc4random_uniform(UInt32(free.count)))
            if free.count != 0 {
                return free[randomIndex]
            }
        }
        return nil;
    }


    static func fillRandom(inout field: Array2D<Character>, direction: TranslationDirection, type: LevelType) {
        var letters: [Character] = (direction == TranslationDirection.Forward ?
                GameDefaults.EnglishUpperCaseLetters :
                GameDefaults.UkrainianUpperCaseCaseLetters);

        if (type == .GrammarExercise) {
            letters = GameDefaults.EnglishUpperCaseLetters
        };


        let count = letters.count;
        let size = field.columns;

        for i: Int in 0 ... size - 1{
            for j: Int in 0 ... size - 1 {
                if (field[i, j] == Grid.EmptyCell) {
                    let randomIndex = Int(arc4random_uniform(UInt32(count)))
                    field[i, j] = letters[randomIndex];
                }
            }
        }
    }
}