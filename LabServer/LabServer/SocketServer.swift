//
//  SocketServer.swift
//  LabServer
//
//  Created by Vika Granadzer on 01.11.2022.
//

import Foundation
import NIO
import NIOConcurrencyHelpers
//import NIOFoundationCompat
var textT = ""
var RemoteAdress = ""
var file_output: File_Output = File_Output()
var command_observer = CommandCreator()
var channel: Channel? = nil

private final class EchoHandler: ChannelInboundHandler, ObservableObject{
    public typealias InboundIn = ByteBuffer
    public typealias OutboundOut = ByteBuffer
    @Published var output: Debug_Text = Debug_Text()
    var alertT = false

    public func channelRegistered(context: ChannelHandlerContext) {
        file_output.writeT(text: " Channel registered")
        print("[lab] channel registered:", context.remoteAddress ?? "unknown")
    }
    
    public func channelUnregistered(context: ChannelHandlerContext) {
        file_output.writeT(text: " Channel unregistered")
        print("[lab] channel unregistered:", context.remoteAddress ?? "unknown")
    }
    
    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let dataWr = unwrapInboundIn(data)
        textT = String(buffer: dataWr)
        command_observer.observe_data(data: textT)
        //output.printText(text: textT, access: access, custom: "textT:")
        file_output.writeSocketMessage(text: " '\(textT)' \(command_observer.command_validation)", remoteAdress: String(describing: context.remoteAddress))
        RemoteAdress = String(describing: context.remoteAddress)
        context.write(NIOAny(ByteBuffer(string: "\(command_observer.size) '\(command_observer.command)' \(command_observer.command_validation)")), promise: nil)
    }

    public func channelReadComplete(context: ChannelHandlerContext) {
        context.flush()
    }

    public func errorCaught(context: ChannelHandlerContext, error: Error) {
        print("[lab] error: ", error)
        file_output.writeSocketMessage(text: " Server answer \(error.localizedDescription)", remoteAdress: String(describing: context.remoteAddress))
        context.close(promise: nil)
    }
}

final class SocketServer{
    @Published var output: Debug_Text = Debug_Text()

    let listeningPort: UInt
    let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    
    init(port: UInt){
        listeningPort = port;
        let bootstrap = ServerBootstrap(group: group)
            .serverChannelOption(ChannelOptions.backlog, value: 256)
            .serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)

            .childChannelInitializer { channel in
                        channel.pipeline.addHandlers(BackPressureHandler(), EchoHandler())
                        }

                    // Enable common socket options at the channel level (TCP_NODELAY and SO_REUSEADDR).
                    // These options are applied to accepted Channels
                    .childChannelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
                    .childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
                    // Message grouping
                    .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 16)
                    // Let Swift-NIO adjust the buffer size, based on actual trafic.
                    .childChannelOption(ChannelOptions.recvAllocator, value: AdaptiveRecvByteBufferAllocator())
            do {
              channel = try bootstrap.bind(host: "0.0.0.0", port: Int(listeningPort)).wait()
              print("[lab] Server started and listening on \(channel!.localAddress!)")
                file_output.writeT(text: " Server started and listening on \(channel!.localAddress!)")
            }
            catch let error {
              print("[lab] Server failed to start: \(error.localizedDescription)")
                file_output.writeT(text: " Server failed to start: \(error.localizedDescription)")
              channel = nil
            }
          }
        deinit {
          output.printText(text: "Channel closed", access: access, custom: "")
          file_output.writeT(text: "Channel closed")
          try? group.syncShutdownGracefully()
            try? channel?.closeFuture.wait()
        }
    }

