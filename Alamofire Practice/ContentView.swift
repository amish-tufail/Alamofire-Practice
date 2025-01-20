//
//  ContentView.swift
//  Alamofire Practice
//
//  Created by Amish Tufail on 20/01/2025.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    var body: some View {
        VStack {
            HStack {
                Button {
                    simpleGetRequest()
                } label: {
                    Text("Simple Get")
                }
                .buttonStyle(.borderedProminent)
                
                Button {
                    paramterSimpleGetRequest()
                } label: {
                    Text("Param Simple Get")
                }
                .buttonStyle(.borderedProminent)
                
                Button {
                    headerSimpleGetRequest()
                } label: {
                    Text("Header Simple Get")
                }
                .buttonStyle(.borderedProminent)
            }
            
            HStack {
                Button {
                    downloadImageAlways()
                } label: {
                    Text("Download Always")
                }
                .buttonStyle(.borderedProminent)
                
                Button {
                    downloadLocally()
                } label: {
                    Text("Download TO")
                }
                .buttonStyle(.borderedProminent)
            }
            
            HStack {
                Button {
                    uploadData()
                } label: {
                    Text("Simple Upload")
                }
                .buttonStyle(.borderedProminent)
                
                Button {
                    multiFormDataUpload()
                } label: {
                    Text("MultiForm Upload")
                }
                .buttonStyle(.borderedProminent)
                
                Button {
                    fileUpload()
                } label: {
                    Text("FIle Upload")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

extension ContentView {
    private func simpleGetRequest() {
                                            // Method: GET, POST, DELETE, PUT
        AF.request("https://httpbin.org/get", method: .get).responseDecodable(of: HTTPBinResponse.self) { dataResponse in
            print(dataResponse.result)
        }
        
        // .response
        // .responseString
        // .responseJSON
        // .responseData
        // .responseDecodable -> The Type in which we want to decode it
    }
    
    private func paramterSimpleGetRequest() {
        // Parameters = Args
        let parameters = ["category": "Movies", "genre": "Action"]
        AF.request("https://httpbin.org/get", parameters: parameters).response { dataResponse in
            debugPrint(dataResponse)
        }
    }
    
    private func headerSimpleGetRequest() {
        let headers: HTTPHeaders = [
                    .authorization(username: "test@email.com", password: "testpassword"),
                    .accept("application/json")
                ]

        let parameters = ["category": "Movies", "genre": "Action"]

       
        
        AF.request("https://httpbin.org/headers", parameters: parameters, headers: headers).response { dataResponse in
            print(dataResponse)
        }
    }
    
    private func downloadImageAlways() {
        AF.download("https://httpbin.org/image/png").responseData { response in
            if let data = response.value {
                let _ = UIImage(data: data)
            }
        }
    }
    
    private func downloadLocally() {
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("image.png")
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        AF.download("https://httpbin.org/image/png", to: destination).response { response in
            debugPrint(response)
            
            if response.error == nil, let imagePath = response.fileURL?.path {
                let _ = UIImage(contentsOfFile: imagePath)
            }
        }
    }
    
    private func uploadData() {
        let data = Data("data".utf8)
        AF.upload(data, to: "https://httpbin.org/post").response { response in
            debugPrint(response)
        }
    }
    
    private func multiFormDataUpload() {
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data("one".utf8), withName: "one")
            multipartFormData.append(Data("two".utf8), withName: "two")
        }, to: "https://httpbin.org/post")
            .response{ response in
                debugPrint(response)
        }
    }
    
    private func fileUpload() {
        let fileURL = Bundle.main.url(forResource: "video", withExtension: "mp4")!
        AF.upload(fileURL, to: "https://httpbin.org/post").response { response in
            debugPrint(response)
        }
    }
}

struct HTTPBinResponse: Decodable {
    let url: String
}
