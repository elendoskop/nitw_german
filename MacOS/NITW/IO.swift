//
//  IO.swift
//  NITW
//
//  Created by Alexey Averkin on 01.10.2023.
//

import Foundation

class IO {

    let files: FileManager
    let workingDir: String
    let yarnDir: String
    let assetDir: String

    init() {
        files = FileManager.default
        workingDir = files.currentDirectoryPath
        yarnDir = workingDir.appending("/Yarn")
        assetDir = workingDir.appending("/TextAsset")
    }

    func setup() {

        print("working dir is: \(workingDir)")

        if !files.fileExists(atPath: yarnDir) {
            do {
                try files.createDirectory(
                    atPath: yarnDir,
                    withIntermediateDirectories: true
                )
                print("Yarn dir created: \(yarnDir)")
            }
            catch {
                print(error.localizedDescription)
                return
            }
        } else {
            print("Yarn dir detected: \(yarnDir)")
        }

        if !files.fileExists(atPath: assetDir) {
            do {
                try files.createDirectory(
                    atPath: assetDir,
                    withIntermediateDirectories: true
                )
                print("TextAsset created: \(assetDir)")
            }
            catch {
                print(error.localizedDescription)
                return
            }
        } else {
            print("TextAsset detected: \(assetDir)")
        }

    }

    func getYarns() throws -> [String: Yarn] {
        print("Reading yarns...")
        let yarnPaths = try files.contentsOfDirectory(atPath: yarnDir)
        var yarns: [String: Yarn] = [:]
        for path in yarnPaths {
            do {
                let name = path.replacingOccurrences(of: ".txt", with: "")
                let script = try NSString(
                    contentsOfFile: "\(yarnDir)/\(path)",
                    encoding: String.Encoding.utf8.rawValue
                ) as String
                let yarn = Yarn(name: name, script: script)
                yarns[path] = yarn
                print("Have read yarn: \(yarn.name)")
            } catch {
                print(error.localizedDescription)
                continue
            }
        }
        return yarns
    }

    func getAssets() throws -> [String: TextAsset] {
        print("Reading TextAssets...")
        let assetsPaths = try files.contentsOfDirectory(atPath: assetDir)
        let decoder = JSONDecoder()
        var assets: [String: TextAsset] = [:]
        for path in assetsPaths {
            do {
                let data = try NSData(contentsOfFile: "\(assetDir)/\(path)") as Data
                let asset = try decoder.decode(TextAsset.self, from: data)
                assets[path] = asset
                print("Have read asset: \(asset.name)")
            } catch {
                print(error.localizedDescription)
                continue
            }
        }
        return assets
    }

    func writeYarnToAsset() throws {
        let yarns = try getYarns()
        let assets = try getAssets()
        for (_, yarn) in yarns {
            for (assetPath, asset) in assets where asset.name == yarn.name {
                var temp = asset
                temp.script = yarn.script
                do {
                    try write(asset: temp, toFile: assetPath)
                    print("Saved asset at: \(assetPath)")
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }

    func writeAssetToYarn() throws {
        let assets = try getAssets()
        for (_, asset) in assets {
            do {
                let yarn = Yarn(name: asset.name, script: asset.script)
                try write(yarn: yarn)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func write(asset: TextAsset, toFile fileName: String) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(asset) as NSData
        let path = "\(assetDir)/\(fileName)"
        data.write(toFile: path, atomically: true)
    }

    private func write(yarn: Yarn) throws {
        let data = yarn.script.data(using: .utf8)! as NSData
        let path = "\(yarnDir)/\(yarn.name).txt"
        data.write(toFile: path, atomically: true)
        print("Saved yarn at: \(path)")
    }

}
