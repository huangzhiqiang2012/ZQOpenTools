//
//  ZQCryptoSwiftController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/6/23.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// CryptoSwift 控制器
class ZQCryptoSwiftController: ZQBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Data from bytes:
        let data = Data([0x01, 0x02, 0x03])
        print("--__--|| data__\(data)")      // 3 bytes
        
        // Data to Array<UInt8>
        let bytes = data.bytes
        print("--__--|| bytes__\(bytes)")    // [1,2,3]
        
        // Hexadecimal encoding
        let bytes1 = Array<UInt8>(hex: "0x010203")
        print("--__--|| bytes1__\(bytes1)")  // [1,2,3]
        
        let hex = bytes1.toHexString()
        print("--__--|| hex__\(hex)")        // "010203"
        
        // Build bytes out of String
        let bytes2:Array<UInt8> = "cipherkey".bytes
        print("--__--|| bytes2__\(bytes2)")  // [99, 105, 112, 104, 101, 114, 107, 101, 121]
        
        // base64
        let base64Str = "ZQCryptoSwiftController".bytes.toBase64()
        print("--__--|| base64Str__\(base64Str)")        // "WlFDcnlwdG9Td2lmdENvbnRyb2xsZXI="

        // Hash struct usage
        let bytes3:Array<UInt8> = [0x01, 0x02, 0x03]
        print("--__--|| bytes3__\(bytes3)")  // [1, 2, 3]

        let digest = "ZQCryptoSwiftController".md5()
        print("--__--|| digest__\(digest)")  // 2718e864b903946141daf1a3b7457263

        let digest1 = Digest.md5(bytes3)
        print("--__--|| digest1__\(digest1)")  // [82, 137, 223, 115, 125, 245, 115, 38, 252, 221, 34, 89, 122, 251, 31, 172]

        let hash = data.md5()
        print("--__--|| hash__\(hash)")     // 16 bytes
        
        let hash1 = data.sha1()
        print("--__--|| hash1__\(hash1)")   // 20 bytes

        let hash2 = data.sha224()
        print("--__--|| hash2__\(hash2)")   // 28 bytes
        
        let hash3 = data.sha256()
        print("--__--|| hash3__\(hash3)")   // 32 bytes

        let hash4 = data.sha384()
        print("--__--|| hash4__\(hash4)")   // 48 bytes

        let hash5 = data.sha512()
        print("--__--|| hash5__\(hash5)")   // 64 bytes

        do {
            var digest = MD5()
            let partial1 = try digest.update(withBytes: [0x31, 0x32])
            print("--__--|| partial1__\(partial1)")   // [1, 35, 69, 103, 137, 171, 205, 239, 254, 220, 186, 152, 118, 84, 50, 16]

            let partial2 = try digest.update(withBytes: [0x33])
            print("--__--|| partial2__\(partial2)")   // [1, 35, 69, 103, 137, 171, 205, 239, 254, 220, 186, 152, 118, 84, 50, 16]

            let result = try digest.finish()
            print("--__--|| result__\(result)")   // [32, 44, 185, 98, 172, 89, 7, 91, 150, 75, 7, 21, 45, 35, 75, 112]

        }
        catch {}
        
        /// 其他情况看 https://github.com/krzyzanowskim/CryptoSwift
        
    }
}
