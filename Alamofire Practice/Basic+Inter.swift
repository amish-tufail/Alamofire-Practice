//
//  Basic+Inter.swift
//  Alamofire Practice
//
//  Created by Amish Tufail on 21/01/2025.
//

import SwiftUI

/*
 
 AF.request -> for small request such as url parameter, small JSON: https://httpbin.org/get
 AF.upload -> large request such as Data, File etc: https://httpbin.org/post
 
 **You can use .cURLDescription { description in print(description) } on your request to get the curl**
 
 */

/*
 
 AF.request -> header, parameter, encoder: JSONParameterEncoder & URLEncodedFormParameterEncoder
 
- Headers that dont change such as: Bearer token should be added to Session: URLSessionConfiguration , so that they are auto added to every request made. Headers -> [HTTPHeader] -> Provided by Alamofire
 
     let headers: HTTPHeaders = ["Authorization": "Bearer VXNlcm5hbWU6UGFzc3dvcmQ="]
     AF.request("https://httpbin.org/headers", headers: headers
 For HTTP headers that do not change, it is recommended to set them on the URLSessionConfiguration so they are automatically applied to any URLSessionTask created by the underlying URLSession.
 
 - Alamofire treats every request as sucess so use validate to cater this: .validate(200..<300) or .validate()
 
 - You can authenticate user using custom header or use Alamofire URLCredential -> See Documentation
 
     let user = "user"
     let password = "password"

     let credential = URLCredential(user: user, password: password, persistence: .forSession)

     AF.request("https://httpbin.org/basic-auth/\(user)/\(password)")
         .authenticate(with: credential)
         .responseDecodable(of: DecodableType.self) { response in
             debugPrint(response)
         }
 
 AF.download
 - You can download content using AF.download: cancel, resume, progress, store to a destination -> See Documentation
 
 AF.upload
 - multiformdata means more than one data object then use this
 
     AF.upload(multipartFormData: { multipartFormData in
         multipartFormData.append(Data("one".utf8), withName: "one")
         multipartFormData.append(Data("two".utf8), withName: "two")
     }, to: "https://httpbin.org/post")
         .responseDecodable(of: DecodableType.self) { response in
             debugPrint(response)
         }
 
 AF.streamRequest:  -> See Documentation
 - handle large downloads or real-time data streams from a server without loading everything into memory at once
 - SEE AT BOTTOM OF THIS FILE MORE EXPLANATION
*/



// --------------------------------------------------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------------------------

//*****
// STREAM REQUEST DETAIL
//*****

/*
 Simplified Guide to Streaming Data with Alamofire
 When you want to handle large downloads or real-time data streams from a server without loading everything into memory at once, Alamofire's DataStreamRequest API is perfect. Here's a beginner-friendly breakdown of how it works:
 Key Concepts
 DataStreamRequest:
 Unlike other requests, this does not store data in memory or save it to disk.
 You add a closure (handler) that gets called every time new data arrives.
 Stream:
 A Stream represents the current event in the stream.
 It has two components:
 Event: The state of the stream (new data or completion).
 Token: Lets you cancel the request.
 Event:
 stream: Contains the new data as a Result.
 complete: Signifies that the stream is done (success, error, or cancellation).
 
 
 
     AF.streamRequest("https://your-server.com/stream")
         .responseStream { stream in
             switch stream.event {
             case .stream(let result):
                 switch result {
                 case .success(let data):
                     print("New data received: \(data)")
                 }
             case .complete(let completion):
                 print("Stream completed: \(completion)")
             }
         }

 ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
 
 1. Producing an InputStream
 What is an InputStream?
 An InputStream is a way to read data sequentially as it arrives, rather than receiving it all at once or storing it in memory. This is useful for handling large or streaming data efficiently.
 Why Use InputStream?
 Sometimes, instead of processing each chunk of data immediately (as with .responseStream), you might want to read the data in smaller chunks yourself. Using an InputStream gives you this control.
 How to Use It?
 Alamofire provides a method called .asInputStream() to create an InputStream from a DataStreamRequest. You can then use this InputStream to read the data.
 
 
     let inputStream = AF.streamRequest("https://example.com/stream")
         .asInputStream() // Convert the stream into an InputStream for manual reading.

     inputStream.open()

     // Read data from the InputStream as needed.
     var buffer = [UInt8](repeating: 0, count: 1024)
     while inputStream.hasBytesAvailable {
         let bytesRead = inputStream.read(&buffer, maxLength: buffer.count)
         if bytesRead > 0 {
             let data = Data(buffer.prefix(bytesRead))
             if let string = String(data: data, encoding: .utf8) {
                 print("Read data: \(string)")
             }
         }
     }

     inputStream.close()
 
 

 */


/*
 When to Use responseStream:
 Goal: Display or handle the data as it arrives without much customization or control.
 Use Case: Perfect for scenarios where you don't need to do complex processing on the stream data (e.g., just display incoming data in real-time).
 How it works: Alamofire handles everything for you. You simply get the data chunks in the closure and can print or use them directly.
 
 
     AF.streamRequest("https://example.com/stream")
         .responseStream { stream in
             switch stream.event {
             case let .stream(result):
                 switch result {
                 case let .success(data):
                     print("Received data: \(data)")  // Auto handles chunks for you
                 case let .failure(error):
                     print("Error: \(error)")
                 }
             case let .complete(completion):
                 print("Stream completed: \(completion)")
             }
         }

 
 When to Use InputStream:
 Goal: Have complete control over how you read, process, and handle incoming data.
 Use Case: Ideal when you need more control, such as converting data to a specific type, applying complex logic, or saving the data for later use (like saving chunks to a file or decoding).
 How it works: You need to manually handle reading, converting (e.g., bytes to strings), and processing the stream data in chunks.

 
     let inputStream = AF.streamRequest("https://example.com/stream")
         .asInputStream()

     inputStream.open()  // Open the stream for reading

     var buffer = [UInt8](repeating: 0, count: 256)  // Small buffer

     while inputStream.hasBytesAvailable {
         let bytesRead = inputStream.read(&buffer, maxLength: buffer.count)  // Read a chunk of data
         if bytesRead > 0 {
             if let string = String(bytes: buffer.prefix(bytesRead), encoding: .utf8) {
                 print("Received chunk: \(string)")  // Process the data manually
             }
         }
     }

     inputStream.close()  // Close when done

*/
