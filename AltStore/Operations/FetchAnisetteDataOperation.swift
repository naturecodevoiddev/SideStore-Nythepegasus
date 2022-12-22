//
//  FetchAnisetteDataOperation.swift
//  AltStore
//
//  Created by Riley Testut on 1/7/20.
//  Copyright © 2020 Riley Testut. All rights reserved.
//

import Foundation

import AltStoreCore
import AltSign
import Roxas

@objc(FetchAnisetteDataOperation)
class FetchAnisetteDataOperation: ResultOperation<ALTAnisetteData>
{
    let context: OperationContext
    
    init(context: OperationContext)
    {
        self.context = context
    }
    
    override func main()
    {
        super.main()
        
        if let error = self.context.error
        {
            self.finish(.failure(error))
            return
        }
        
        let fm = FileManager.default
        let documentsPath = fm.documentsDirectory.appendingPathComponent("adi.pb")
        print("ADI Path: \(documentsPath)")
        
        let url = AnisetteManager.currentURL
        DLOG("Anisette URL: %@", url.absoluteString)
        
        let session = URLSession.shared
        
        var postData = Data()

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=ebd46b494f8b3f6926db4f30a3f371ae", forHTTPHeaderField: "Content-Type")
        
        do {
            // Get the raw data from the file.
            let rawData: Data = try Data(contentsOf: documentsPath)
            print("ADI EXISTS")
            postData.append("--ebd46b494f8b3f6926db4f30a3f371ae\r\n".data(using: .utf8)!)
            postData.append("Content-Disposition: form-data; name=\"adi.pb\"; filename=\"adi.pb\"\r\n\r\n".data(using: .utf8)!)
            for byte in rawData {
                postData.append(byte)
            }
            postData.append("\r\n--ebd46b494f8b3f6926db4f30a3f371ae\r\n".data(using: .utf8)!)
        } catch let error as NSError {
            self.fetchADIFile(session: URLSession.shared)
            self.finish(.failure(error))
        }
        
        let task = session.uploadTask(with: request, from: postData, completionHandler: { data, response, error in
            if let data = data {
                do {
                    print(String(data: data, encoding: .utf8))
                    // make sure this JSON is in the format we expect
                    // convert data to json
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
                        // try to read out a dictionary
                        //for some reason serial number isn't needed but it doesn't work unless it has a value
                        let formattedJSON: [String: String] = ["machineID": json["X-Apple-I-MD-M"]!, "oneTimePassword": json["X-Apple-I-MD"]!, "localUserID": json["X-Apple-I-MD-LU"]!, "routingInfo": json["X-Apple-I-MD-RINFO"]!, "deviceUniqueIdentifier": json["X-Mme-Device-Id"]!, "deviceDescription": json["X-MMe-Client-Info"]!, "date": json["X-Apple-I-Client-Time"]!, "locale": json["X-Apple-Locale"]!, "timeZone": json["X-Apple-I-TimeZone"]!, "deviceSerialNumber": "1"]
                        print(formattedJSON)

                        if let anisette = ALTAnisetteData(json: formattedJSON) {
                            self.finish(.success(anisette))
                        }
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                    self.finish(.failure(error))
                }
            }
        })

        task.resume()
    }
    
    func fetchADIFile(session: URLSession) {
        
        let fm = FileManager.default
        let documentsPath = fm.documentsDirectory.appendingPathComponent("adi.pb")

        print("ADI URL: \(AnisetteManager.currentURL.appendingPathComponent("adi_file").absoluteString)")
        let task = URLSession.shared.downloadTask(with: AnisetteManager.currentURL.appendingPathComponent("adi_file")) { localURL, urlResponse, error in
            if let localURL = localURL {
                print("localURL!")
                print(localURL.absoluteString)
                if let data = try? Data(contentsOf: localURL) {
                    print("data!")
                    do {
                        try data.write(to: documentsPath)
                        print("WROTE ADI?")
                    } catch let error as NSError {
                        print("ADI WRITE ERROR: \(error.domain)")
                    }
                }
            }
        }
        
        task.resume()
    }
}
