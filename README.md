# Uni Mobil Uygulaması

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

"Uni", Flutter kullanılarak geliştirilmiş, modern ve çok dilli bir mobil uygulamadır. Bu proje, temiz kod mimarisi, etkili durum yönetimi ve reklam entegrasyonu gibi mobil uygulama geliştirmenin temel prensiplerini sergilemek amacıyla oluşturulmuştur.

## Ekran Görüntüleri

*(Buraya uygulamanızın ekran görüntülerini ekleyin. Örneğin:)*

| Onboarding Ekranı | Ana Ekran | Özet Ekranı |
| :---------------: | :------: | :----------: |
|  <img src="" width="200">   | <img src="" width="200"> | <img src="" width="200">  |


## ✨ Özellikler

- **Çoklu Dil Desteği:** `flutter_localizations` ve `intl` paketleri kullanılarak uluslararasılaştırma (i18n) desteği.
- **Yerel Veri Depolama:** Kullanıcı ayarları ve tercihleri için `shared_preferences` kullanımı.
- **Reklam Entegrasyonu:** `google_mobile_ads` paketi ile gelir modeli oluşturma.
- **Durum Yönetimi:** `Provider` paketi ile verimli ve ölçeklenebilir state management.
- **Temiz Mimarî:** Sorumlulukların ayrıldığı, modüler ve anlaşılır bir klasör yapısı (`screens`, `services`, `widgets` vb.).

## 🛠️ Kullanılan Teknolojiler

- **Flutter:** Ana geliştirme framework'ü.
- **Dart:** Programlama dili.
- **Provider:** Durum yönetimi.
- **shared_preferences:** Basit anahtar-değer depolaması.
- **google_mobile_ads:** Google mobil reklamları.
- **flutter_localizations & intl:** Uluslararasılaştırma ve yerelleştirme.
- **flutter_launcher_icons:** Uygulama ikonlarını otomatize etmek için.

## 🚀 Kurulum ve Başlatma

Projeyi yerel makinenizde çalıştırmak için aşağıdaki adımları izleyin:

1.  **Projeyi Klonlayın:**
    ```bash
    git clone https://github.com/kullanici-adiniz/Uni.git
    cd Uni
    ```

2.  **Bağımlılıkları Yükleyin:**
    ```bash
    flutter pub get
    ```

3.  **Uygulamayı Çalıştırın:**
    ```bash
    flutter run
    ```

## 📂 Proje Yapısı

Projenin `lib` klasörü, uygulamanın temel mantığını içerir ve aşağıdaki gibi yapılandırılmıştır:

```
lib/
├── languages/      # Dil ve yerelleştirme dosyaları
├── models/         # Veri modelleri
├── screens/        # Uygulama ekranları (UI)
├── services/       # Arka plan servisleri (API, veritabanı vb.)
├── theme/          # Tema ve renk tanımlamaları
├── utils/          # Yardımcı fonksiyonlar ve sınıflar
├── widgets/        # Tekrar kullanılabilir widget'lar
└── main.dart       # Uygulamanın başlangıç noktası
```
