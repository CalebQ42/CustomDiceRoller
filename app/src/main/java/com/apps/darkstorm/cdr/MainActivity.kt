package com.apps.darkstorm.cdr

import android.os.Bundle
import android.support.design.widget.CoordinatorLayout
import android.support.design.widget.NavigationView
import android.support.v4.view.GravityCompat
import android.support.v4.widget.DrawerLayout
import android.support.v7.app.ActionBarDrawerToggle
import android.support.v7.app.AppCompatActivity
import android.view.Menu
import android.view.MenuItem
import android.view.View
import com.apps.darkstorm.cdr.custVars.FloatingActionMenu
import kotlinx.android.synthetic.main.activity_main.*
import kotlinx.android.synthetic.main.app_bar_main.*
import org.jetbrains.anko.browse
import org.jetbrains.anko.find


class MainActivity : AppCompatActivity(), NavigationView.OnNavigationItemSelectedListener{

    override fun onCreate(savedInstanceState: Bundle?) {
        if((application as CDR).prefs.getBoolean(getString(R.string.theme_key),false))
            setTheme(R.style.LightAppTheme)
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        setSupportActionBar(toolbar)
        val toggle = ActionBarDrawerToggle(
                this, drawer_layout, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close)
        drawer_layout.addDrawerListener(toggle)
        drawer_layout.addDrawerListener(object: DrawerLayout.DrawerListener{
            override fun onDrawerStateChanged(newState: Int) {}
            override fun onDrawerSlide(drawerView: View, slideOffset: Float) { (application as CDR).fab.closeMenu() }
            override fun onDrawerClosed(drawerView: View) {}
            override fun onDrawerOpened(drawerView: View) { (application as CDR).fab.closeMenu() }
        })
        toolbar.setOnTouchListener { _, _ ->
            (application as CDR).fab.closeMenu()
            false
        }
        toggle.syncState()
        nav_view.setNavigationItemSelectedListener(this)
        (application as CDR).fab = FloatingActionMenu(find<CoordinatorLayout>(R.id.coord))
        when((application as CDR).prefs.getInt(getString(R.string.default_section_key),0)){
            0->fragmentManager.beginTransaction().replace(R.id.content_main,FormulaFragment())
                    .setCustomAnimations(android.R.animator.fade_in,android.R.animator.fade_out).commit()
            1->fragmentManager.beginTransaction().replace(R.id.content_main,ListFragment.newInstance(false))
                    .setCustomAnimations(android.R.animator.fade_in,android.R.animator.fade_out).commit()
            2->fragmentManager.beginTransaction().replace(R.id.content_main,ListFragment.newInstance(true))
                        .setCustomAnimations(android.R.animator.fade_in,android.R.animator.fade_out).commit()
        }
    }

    override fun onBackPressed() {
        if((application as CDR).fab.isOpen)
            (application as CDR).fab.closeMenu()
        else {
            val drawer = findViewById<View>(R.id.drawer_layout) as DrawerLayout
            if (drawer.isDrawerOpen(GravityCompat.START))
                drawer.closeDrawer(GravityCompat.START)
            else {
                val cur = fragmentManager.findFragmentById(R.id.content_main)
                if(cur != null){
                    if (cur.childFragmentManager.backStackEntryCount > 0)
                        cur.childFragmentManager.popBackStack()
                    else
                        super.onBackPressed()
                }else
                    super.onBackPressed()
            }
        }
    }
    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        menuInflater.inflate(R.menu.main, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        (application as CDR).fab.closeMenu()
        return when (item.itemId) {
            R.id.g_plus -> {
                browse("https://plus.google.com/communities/117741233533206107778")
                true
            }
            else -> super.onOptionsItemSelected(item)
        }
    }

    override fun onNavigationItemSelected(item: MenuItem): Boolean {
        val cur = fragmentManager.findFragmentById(R.id.content_main)
        when (item.itemId) {
            R.id.formula ->{
                if(cur is FormulaFragment)
                    fragmentManager.beginTransaction().replace(R.id.content_main,FormulaFragment())
                        .setCustomAnimations(android.R.animator.fade_in,android.R.animator.fade_out).commit()
                else
                    fragmentManager.beginTransaction().replace(R.id.content_main,FormulaFragment())
                        .setCustomAnimations(android.R.animator.fade_in,android.R.animator.fade_out).addToBackStack("formula").commit()
            }
            R.id.settings->{
                if(cur is SettingsFragment)
                    fragmentManager.beginTransaction().replace(R.id.content_main,SettingsFragment())
                            .setCustomAnimations(android.R.animator.fade_in,android.R.animator.fade_out).commit()
                else
                    fragmentManager.beginTransaction().replace(R.id.content_main,SettingsFragment())
                            .setCustomAnimations(android.R.animator.fade_in,android.R.animator.fade_out).addToBackStack("settings").commit()
            }
            R.id.die->{
                if(cur is ListFragment && !cur.dice)
                    fragmentManager.beginTransaction().replace(R.id.content_main,ListFragment.newInstance(false))
                            .setCustomAnimations(android.R.animator.fade_in,android.R.animator.fade_out).commit()
                else
                    fragmentManager.beginTransaction().replace(R.id.content_main,ListFragment.newInstance(false))
                            .setCustomAnimations(android.R.animator.fade_in,android.R.animator.fade_out).addToBackStack("die").commit()
            }
            R.id.dice->{
                if(cur is ListFragment && cur.dice)
                    fragmentManager.beginTransaction().replace(R.id.content_main,ListFragment.newInstance(true))
                            .setCustomAnimations(android.R.animator.fade_in,android.R.animator.fade_out).commit()
                else
                    fragmentManager.beginTransaction().replace(R.id.content_main,ListFragment.newInstance(true))
                            .setCustomAnimations(android.R.animator.fade_in,android.R.animator.fade_out).addToBackStack("die").commit()
            }
        }
        drawer_layout.closeDrawer(GravityCompat.START)
        return true
    }


}
