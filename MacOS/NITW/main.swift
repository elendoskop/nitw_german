//
//  main.swift
//  NITW
//
//  Created by Alexey Averkin on 29.09.2023.
//

import Foundation

func main() {
    while true {
        print(
            """
            Select the command:
            1 - JSON to Yarn
            2 - YARN to JSON
            3 - Exit
            """
        )

        print("Command (press enter to submit): ")
        guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            continue
        }

        let io = IO()
        io.setup()

        switch input {
        case "1":
            do {
                try io.writeAssetToYarn()
            } catch {
                print(error.localizedDescription)
            }
        case "2":
            do {
                try io.writeYarnToAsset()
            } catch {
                print(error.localizedDescription)
            }
        case "3":
            exit(0)
        default:
            print("wrong input")
        }

    }
}

main()
