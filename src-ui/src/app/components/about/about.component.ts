import { Component, inject, LOCALE_ID } from '@angular/core'
import { RouterModule } from '@angular/router'
import { NgxBootstrapIconsModule } from 'ngx-bootstrap-icons'
import { environment } from 'src/environments/environment'
import { LogoComponent } from '../common/logo/logo.component'

@Component({
  selector: 'pngx-about',
  templateUrl: './about.component.html',
  styleUrls: ['./about.component.scss'],
  imports: [LogoComponent, NgxBootstrapIconsModule, RouterModule],
})
export class AboutComponent {
  private localeId = inject(LOCALE_ID)

  get isArabic(): boolean {
    return this.localeId.startsWith('ar')
  }

  get versionString(): string {
    return `${environment.appTitle} v${environment.version}`
  }
}
