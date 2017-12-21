package com.apps.darkstorm.cdr

import android.os.Bundle
import android.support.design.widget.NavigationView
import android.support.v4.view.GravityCompat
import android.support.v7.app.ActionBarDrawerToggle
import android.support.v7.app.AppCompatActivity
import android.view.Menu
import android.view.MenuItem
import kotlinx.android.synthetic.main.activity_main.*
import kotlinx.android.synthetic.main.app_bar_main.*
import org.jetbrains.anko.browse

class MainActivity : AppCompatActivity(), NavigationView.OnNavigationItemSelectedListener{

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        setSupportActionBar(toolbar)
        val toggle = ActionBarDrawerToggle(
                this, drawer_layout, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close)
        drawer_layout.addDrawerListener(toggle)
        toggle.syncState()
        nav_view.setNavigationItemSelectedListener(this)
        when((application as CDR).prefs.getInt(getString(R.string.default_section_key),0)){
            0->fragmentManager.beginTransaction().replace(R.id.content_main,ListFragment.newInstance(false))
                    .setCustomAnimations(android.R.animator.fade_in,android.R.animator.fade_out).commit()
            1->fragmentManager.beginTransaction().replace(R.id.content_main,ListFragment.newInstance(true))
                    .setCustomAnimations(android.R.animator.fade_in,android.R.animator.fade_out).commit()
            2->fragmentManager.beginTransaction().replace(R.id.content_main,FormulaFragment())
                    .setCustomAnimations(android.R.animator.fade_in,android.R.animator.fade_out).commit()
        }
    }
    override fun onBackPressed() {
        if (drawer_layout.isDrawerOpen(GravityCompat.START)) {
            drawer_layout.closeDrawer(GravityCompat.START)
        } else {
            super.onBackPressed()
        }
    }
    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        menuInflater.inflate(R.menu.main, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean = when (item.itemId) {
        R.id.g_plus ->{
            browse("https://plus.google.com/communities/117741233533206107778")
            true
        }
        else -> super.onOptionsItemSelected(item)
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
