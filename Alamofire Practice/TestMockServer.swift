//
//  TestMockServer.swift
//  Alamofire Practice
//
//  Created by Amish Tufail on 22/01/2025.
//

import SwiftUI
import Alamofire

struct UserContent: Codable {
    var id: String
    var name: String
    var avatar: String
}

struct TestMockServer: View {
    @State var objects: [UserContent] = []
    var body: some View {
        VStack {
            List {
                ForEach(objects, id:\.id) { obj in
                    HStack {
                        Text("\(obj.id) -\(obj.name)")
                    }
                }
            }
            
            HStack {
                Button {
                    getData()
                } label: {
                    Text("Get")
                }
                Button {
                    postData()
                } label: {
                    Text("Post")
                }
            }
        }
    }
}

#Preview {
    TestMockServer()
}

extension TestMockServer {
    private func getData() {
        let url = "https://678fef6349875e5a1a93e1a3.mockapi.io/test-api/v1/basic"
        AF.request(url).responseDecodable(of: [UserContent].self) { response in
            switch response.result {
            case .success(let value) :
                self.objects = value
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    private func postData() {
        let content = UserContent(id: "5", name: "Amish", avatar: "empty string")
        let url = "https://678fef6349875e5a1a93e1a3.mockapi.io/test-api/v1/basic"
        AF.request(url, method: .post, parameters: content, encoder: JSONParameterEncoder.default).response { response in
            switch response.result {
            case .success(let value) :
                getData()
                if let data = value, let responseString = String(data: data, encoding: .utf8) {
                           print("Response: \(responseString)")
                       } else {
                           print("Failed to decode response data.")
                       }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}


