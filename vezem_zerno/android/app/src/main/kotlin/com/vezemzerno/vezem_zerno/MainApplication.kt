package com.vezemzerno.vezem_zerno

import android.app.Application

import com.yandex.mapkit.MapKitFactory

class MainApplication: Application() {
  override fun onCreate() {
    super.onCreate()
    MapKitFactory.setApiKey("ca6c4276-c8f0-419a-bcbe-1c2101182e25")
  }
}