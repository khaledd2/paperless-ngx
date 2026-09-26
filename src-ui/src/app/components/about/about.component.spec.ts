import { provideHttpClient, withInterceptorsFromDi } from '@angular/common/http'
import { provideHttpClientTesting } from '@angular/common/http/testing'
import { ComponentFixture, TestBed } from '@angular/core/testing'
import { By } from '@angular/platform-browser'
import { RouterModule } from '@angular/router'
import { NgxBootstrapIconsModule, allIcons } from 'ngx-bootstrap-icons'
import { routes } from 'src/app/app-routing.module'
import { LogoComponent } from '../common/logo/logo.component'
import { AboutComponent } from './about.component'

describe('AboutComponent', () => {
  let component: AboutComponent
  let fixture: ComponentFixture<AboutComponent>

  beforeEach(async () => {
    TestBed.configureTestingModule({
      imports: [
        NgxBootstrapIconsModule.pick(allIcons),
        AboutComponent,
        LogoComponent,
        RouterModule.forRoot(routes),
      ],
      providers: [
        provideHttpClient(withInterceptorsFromDi()),
        provideHttpClientTesting(),
      ],
    }).compileComponents()

    fixture = TestBed.createComponent(AboutComponent)
    component = fixture.componentInstance

    fixture.detectChanges()
  })

  it('should create component', () => {
    expect(component).toBeTruthy()
    expect(fixture.nativeElement.textContent).toContain(
      'Shift for Digital Solutions'
    )
    expect(fixture.debugElement.queryAll(By.css('a'))).toHaveLength(3)
  })
})
