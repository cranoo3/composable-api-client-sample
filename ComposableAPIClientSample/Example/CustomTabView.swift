//
//  CustomTabView.swift
//  ComposableAPIClientSample
//
//  Created by cranoo on 2025/06/02.
//

import SwiftUI

enum Selected: Hashable {
    case home
    case profile
}

struct CustomTabView: View {
    @State var selected = Selected.home
    @State var groupedIcon: UIImage? = nil
    
    var body: some View {
        TabView(selection: $selected) {
            SampleView()
                .tabItem {
                    if let groupedIcon {
                        Image(uiImage: groupedIcon)
                    }
                    Text("Hello, world")
                }
                .tag(Selected.home)
            
            SampleView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
        }
        .onAppear {
            groupedIcon = ImageCombiner.combineImages(backgroundImage: UIImage(systemName: "house.fill")!, foregroundImage: UIImage(resource: .ellipse2), canvasSize: CGSize(width: 20, height: 20))
        }
    }
}

class ImageCombiner {
    
    /// 2つの画像を結合する
    /// - Parameters:
    ///   - backgroundImage: 後方（背景）画像
    ///   - foregroundImage: 前方（前景）画像
    ///   - canvasSize: 結合後の画像サイズ
    ///   - backgroundSize: 背景画像の描画サイズ（nilの場合はcanvasSizeと同じ）
    ///   - backgroundPosition: 背景画像の描画位置（デフォルト: .zero）
    ///   - foregroundPosition: 前景画像の描画位置（デフォルト: .zero）
    /// - Returns: 結合された画像、失敗時はnil
    static func combineImages(
        backgroundImage: UIImage,
        foregroundImage: UIImage,
        canvasSize: CGSize,
        backgroundSize: CGSize? = nil,
        backgroundPosition: CGPoint = .zero,
        foregroundPosition: CGPoint = .zero
    ) -> UIImage? {
        
        // 画像コンテキストを作成
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        // 背景を透明にする
        context.clear(CGRect(origin: .zero, size: canvasSize))
        
        // 背景画像のサイズを決定
        let bgSize = backgroundSize ?? canvasSize
        let backgroundRect = CGRect(
            x: backgroundPosition.x,
            y: backgroundPosition.y,
            width: bgSize.width,
            height: bgSize.height
        )
        
        // 前景画像のサイズ（元のサイズを保持）
        let foregroundRect = CGRect(
            x: foregroundPosition.x,
            y: foregroundPosition.y,
            width: foregroundImage.size.width,
            height: foregroundImage.size.height
        )
        
        // 背景画像を描画
        backgroundImage.draw(in: backgroundRect)
        
        // 前景画像を描画
        foregroundImage.draw(in: foregroundRect)
        
        // 結合された画像を取得
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// 背景画像のサイズを比率で指定して結合する
    /// - Parameters:
    ///   - backgroundImage: 後方（背景）画像
    ///   - foregroundImage: 前方（前景）画像
    ///   - canvasSize: 結合後の画像サイズ
    ///   - backgroundScale: 背景画像の拡大縮小比率（1.0が元サイズ）
    ///   - backgroundPosition: 背景画像の描画位置
    ///   - foregroundPosition: 前景画像の描画位置
    /// - Returns: 結合された画像、失敗時はnil
    static func combineImagesWithScale(
        backgroundImage: UIImage,
        foregroundImage: UIImage,
        canvasSize: CGSize,
        backgroundScale: CGFloat = 1.0,
        backgroundPosition: CGPoint = .zero,
        foregroundPosition: CGPoint = .zero
    ) -> UIImage? {
        
        let scaledBackgroundSize = CGSize(
            width: backgroundImage.size.width * backgroundScale,
            height: backgroundImage.size.height * backgroundScale
        )
        
        return combineImages(
            backgroundImage: backgroundImage,
            foregroundImage: foregroundImage,
            canvasSize: canvasSize,
            backgroundSize: scaledBackgroundSize,
            backgroundPosition: backgroundPosition,
            foregroundPosition: foregroundPosition
        )
    }
}

struct SampleView: View {
    var body: some View {
        Text("Hello, World!")
    }
}


#Preview {
    CustomTabView()
}
